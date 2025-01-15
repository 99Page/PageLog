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
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

class ChatViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let chatStackView = UIStackView()
    
    private let store: StoreOf<ChatFeature>
    
    init(store: StoreOf<ChatFeature>) {
        self.store = store
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
        scrollView.addSubview(chatStackView)
        
        setUpChatStackView()
    }
    
    private func setUpChatStackView() {
        chatStackView.axis = .vertical
        chatStackView.spacing = 12
        chatStackView.distribution = .equalSpacing
    }
    
    private func setUpConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
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
        
        chatStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        observe { [weak self] in
            guard let self else { return }
            
            // Add new chat messages
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
    
    UIViewControllerPreview {
        ChatViewController(store: Store(initialState: state) {
            ChatFeature()
        })
    }
}
