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

struct ChatState: Equatable, Identifiable {
    let id = UUID()
    let text: String
    let sendDate: Date
    let isMyMessage: Bool
    
    static var stubs: [ChatState] {
        [
            ChatState(text: "Hello1", sendDate: .now, isMyMessage: true),
            ChatState(text: "World1", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello2", sendDate: .now, isMyMessage: true),
            ChatState(text: "World2", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello3", sendDate: .now, isMyMessage: true),
            ChatState(text: "World3", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello4", sendDate: .now, isMyMessage: true),
            ChatState(text: "World4", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello5", sendDate: .now, isMyMessage: true),
            ChatState(text: "World5", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello6", sendDate: .now, isMyMessage: true),
            ChatState(text: "World6", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello7", sendDate: .now, isMyMessage: true),
            ChatState(text: "World7", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello8", sendDate: .now, isMyMessage: true),
            ChatState(text: "World8", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello9", sendDate: .now, isMyMessage: true),
            ChatState(text: "World9", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello10", sendDate: .now, isMyMessage: true),
            ChatState(text: "World10", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello11", sendDate: .now, isMyMessage: true),
            ChatState(text: "World11", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello12", sendDate: .now, isMyMessage: true),
            ChatState(text: "World12", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello13", sendDate: .now, isMyMessage: true),
            ChatState(text: "World13", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello14", sendDate: .now, isMyMessage: true),
            ChatState(text: "World14", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello15", sendDate: .now, isMyMessage: true),
            ChatState(text: "World15", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello16", sendDate: .now, isMyMessage: true),
            ChatState(text: "World16", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello17", sendDate: .now, isMyMessage: true),
            ChatState(text: "World17", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello18", sendDate: .now, isMyMessage: true),
            ChatState(text: "World18", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello19", sendDate: .now, isMyMessage: true),
            ChatState(text: "World19", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello20", sendDate: .now, isMyMessage: true),
            ChatState(text: "World20", sendDate: .now, isMyMessage: false),
            
        ]
    }
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
        case scrollTapped
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
                default:
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
            case .scrollTapped:
                state.chatInput.isEditing = false
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
    
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    init(store: StoreOf<ChatFeature>) {
        self.store = store
        self.chatInputView = ChatInputView(store: store.scope(state: \.chatInput, action: \.chatInput))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        setUpScrollView()
        setUpChatStackView()
        addKeyboardObserver()
    }
    
    private func addKeyboardObserver() {
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpScrollView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.cancelsTouchesInView = false // Allow scroll view to handle touches
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.alwaysBounceVertical = true
    }
    
    private func setUpChatStackView() {
        chatStackView.axis = .vertical
        chatStackView.spacing = 12
        chatStackView.distribution = .equalSpacing
    }
    
    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.trailing.equalToSuperview()
            self.containerViewBottomConstraint = make.bottom.equalToSuperview().constraint.layoutConstraints.first
        }
        
        chatInputView.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        let scrollViewHeight = scrollView.bounds.size.height
        let keyboardHeight = keyboardFrame.height

        UIView.animate(withDuration: animationDuration) {
            // Scroll adjustment
            self.adjustScrollForKeyboardAppearance(scrollHeight: scrollViewHeight, keyboardHeight: keyboardHeight)
            self.adjustContainerViewForKeyboard(height: keyboardHeight, animationDuration: animationDuration)
            self.view.layoutIfNeeded() // Recalculate layout changes
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        let scrollContentOffsetBefore = scrollView.contentOffset.y
        // Adjust containerView bottom constraint
        adjustContainerViewForKeyboard(height: 0, animationDuration: animationDuration)
        adjustScrollForKeyboardDisappearance(currentOffsetY: scrollContentOffsetBefore, keyboardHeight: keyboardFrame.height, animationDuration: animationDuration)
    }

    /// Adjusts the containerView bottom constraint for the keyboard
    private func adjustContainerViewForKeyboard(height: CGFloat, animationDuration: TimeInterval) {
        containerViewBottomConstraint?.constant = -height
        self.view.layoutIfNeeded()
    }

    /// Adjusts the scrollView content offset for the keyboard appearance.
    private func adjustScrollForKeyboardAppearance(scrollHeight: CGFloat, keyboardHeight: CGFloat) {
        let currentOffset = scrollView.contentOffset
        let contentBottomY = scrollView.contentSize.height
        let remainingVisibleArea = scrollHeight - contentBottomY

        if currentOffset.y == 0 && remainingVisibleArea < keyboardHeight && remainingVisibleArea > 0{
            let newOffsetY = max(0, keyboardHeight - remainingVisibleArea)
            let newOffset = CGPoint(x: currentOffset.x, y: newOffsetY)
            scrollView.setContentOffset(newOffset, animated: true)
        } else if currentOffset.y > 0 {
            let newOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + keyboardHeight)
            scrollView.setContentOffset(newOffset, animated: true)
        }
    }
    
    /// Adjusts the scrollView content offset when the keyboard disappears.
    ///
    /// - Parameters:
    ///   - currentOffsetY: The current vertical offset of the scrollView.
    ///   - keyboardHeight: The height of the keyboard that was dismissed.
    ///   - animationDuration: The duration of the keyboard dismissal animation.
    private func adjustScrollForKeyboardDisappearance(currentOffsetY: CGFloat, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        // Ensure the keyboard height is valid and there is enough offset to adjust
        guard keyboardHeight > 0, currentOffsetY >= keyboardHeight else {
            return
        }
        
        let newContentOffset = CGPoint(x: 0, y: currentOffsetY - keyboardHeight)
        
        self.scrollView.setContentOffset(newContentOffset, animated: false)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        store.send(.scrollTapped)
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
