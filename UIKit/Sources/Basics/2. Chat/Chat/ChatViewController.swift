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
    }
    
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
                    return .none
                case .textDidChange:
                    return .none
                }
            }
        }
    }
}

class ChatViewController: UIViewController {
    
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
        
        view.addSubview(scrollView)
        view.addSubview(chatInputView)
        
        scrollView.addSubview(chatStackView)
        setUpChatStackView()
    }
    
    private func setUpChatStackView() {
        chatStackView.axis = .vertical
        chatStackView.spacing = 12
        chatStackView.distribution = .equalSpacing
    }
    
    private func setUpConstraints() {
        chatInputView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(chatInputView.snp.top)
            make.left.trailing.equalToSuperview()
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
