//
//  ChatViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import ComposableArchitecture
import Combine
import SwiftUI
import MessageKit

struct ChatState: Equatable {
    let text: String
    let sendDate: Date
    let isMyMessage: Bool
}

@Reducer
struct ChatFeature {
    @ObservableState
    struct State: Equatable {
        var chats: [ChatState]
        var chatInput = ChatInputFeature.State()
    }
    
    enum Action {
        case chatInput(ChatInputFeature.Action)
        case viewDidAppear
        case receivedMessage(Result<WebSocketClient.Message, any Error>)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.webSocket) var webSocket
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.chatInput, action: \.chatInput) {
            ChatInputFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .chatInput(action):
                switch action {
                case let .sendButtonTapped(text):
                    guard !text.isEmpty else { return .none }
                    let newChat = ChatState(text: text, sendDate: .now, isMyMessage: true)
                    state.chats.append(newChat)
                    
                    return .run { send in
                        try await self.webSocket.send(WebSocketClient.ID(), .string(text))
                    }
                case .textDidChange:
                    return .none
                }
            case .viewDidAppear:
                return .run { send in
                    let actions = await self.webSocket.open(
                        WebSocketClient.ID(),
                        URL(string: "wss://echo.websocket.events")!,
                        []
                    )
                    
                    await withThrowingTaskGroup(of: Void.self) { group in
                        for await action in actions {
                            // NB: Can't call `await send` here outside of `group.addTask` due to task local
                            //     dependency mutation in `Effect.{task,run}`. Can maybe remove that explicit task
                            //     local mutation (and this `addTask`?) in a world with
                            //     `Effect(operation: .run { ... })`?
                            switch action {
                            case .didOpen:
                                group.addTask {
                                    while !Task.isCancelled {
                                        try await self.clock.sleep(for: .seconds(10))
                                        try? await self.webSocket.sendPing(WebSocketClient.ID())
                                    }
                                }
                                group.addTask {
                                    for await result in try await self.webSocket.receive(WebSocketClient.ID()) {
                                        await send(.receivedMessage(result))
                                    }
                                }
                            case .didClose:
                                return
                            }
                        }
                    }
                }
            case .receivedMessage(.failure):
                return .none
            case let .receivedMessage(.success(message)):
                if case let .string(string) = message {
                    let newChat = ChatState(text: string, sendDate: .now, isMyMessage: false)
                    state.chats.append(newChat)
                }
                return .none
            }
        }
    }
}

class ChatViewController: UIViewController {
    
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    private let chatStackView = UIStackView()
    private let chatInputView: ChatInputView
    
    private let store: StoreOf<ChatFeature>
    
    init(store: StoreOf<ChatFeature>) {
        self.store = store
        self.chatInputView = ChatInputView(store: store.scope(state: \.chatInput, action: \.chatInput))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUpViewController()
        setUpConstraints()
        bind()
    }
    
    private func setUpViewController() {
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.addSubview(scrollView)
        containerView.addSubview(chatInputView)
        
        scrollView.addSubview(chatStackView)
        
        setUpChatStackView()
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpChatStackView() {
        chatStackView.axis = .vertical
        chatStackView.spacing = 12
        chatStackView.distribution = .equalSpacing
    }
    
    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.left.trailing.equalToSuperview()
        }
        
        chatInputView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(chatInputView.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        chatStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading).offset(10)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-10)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width).offset(-20)
        }
    }
    
    private func bind() {
        observe { [weak self] in
            guard let self else { return }
            
            /// 제거해주는건데 observe 내부에서 해줘야한다.
            self.chatStackView.arrangedSubviews.forEach { subview in
                self.chatStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
            
            store.chats.forEach { chat in
                let label = UILabel()
                label.text = chat.text
                label.numberOfLines = 0
                label.textColor = .black
                
                if chat.isMyMessage {
                    label.textAlignment = .right
                } else {
                    label.textAlignment = .left
                }
                
                self.chatStackView.addArrangedSubview(label)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.send(.viewDidAppear)
    }
    
    /// Handle keyboard appearance
    @objc private func keyboardWillShow(_ notification: Notification) {
        adjustForKeyboard(notification: notification, isShowing: true)
    }
    
    /// Handle keyboard disappearance
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustForKeyboard(notification: notification, isShowing: false)
    }
    
    /// Adjust the view for the keyboard
    private func adjustForKeyboard(notification: Notification, isShowing: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        // Adjust the bottom constraint
        let keyboardHeight = isShowing ? keyboardFrame.height : 0
        UIView.animate(withDuration: animationDuration) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }
    }
}

#Preview {
    
    let state = ChatFeature.State(chats: [
        ChatState(text: "Hello", sendDate: .now, isMyMessage: true),
        ChatState(text: "World", sendDate: .now, isMyMessage: false)
    ])
    
    ChatViewController(store: Store(initialState: state) {
        ChatFeature()
            ._printChanges()
    })
}
