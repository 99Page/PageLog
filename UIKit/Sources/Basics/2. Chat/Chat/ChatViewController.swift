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
            make.leading.equalToSuperview()
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
                
                if chat.isMyMessage {
                    let myChatBubbleView = MyChatView(state: chat)
                    self.chatStackView.addArrangedSubview(myChatBubbleView)
                } else {
                    let label = UILabel()
                    label.text = chat.text
                    label.numberOfLines = 0
                    label.textColor = .black
                    label.textAlignment = .left
                    self.chatStackView.addArrangedSubview(label)
                }
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
