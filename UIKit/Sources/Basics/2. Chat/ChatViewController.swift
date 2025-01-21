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
import AudioToolbox

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let containerView = UIView()
    private let chatInputView: ChatInputView
    private let showNewMessageButton = UIButton(type: .custom)
    
    let tableView = UITableView()
    
    let store: StoreOf<ChatFeature>
    
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
        
        /// 추가된 뷰의 순서대로 Z축이 결정됩니다.
        /// tableView - chatInputView - showNewMessageButton 순으로 뷰가 중첩됩니다. 
        containerView.addSubview(tableView)
        containerView.addSubview(chatInputView)
        containerView.addSubview(showNewMessageButton)
        
        setUpShowNewMessageButton()
        setUpTableView()
        
        addKeyboardObserver()
    }
    
    private func setUpShowNewMessageButton() {
        showNewMessageButton.setTitle("새 메시지 보기", for: .normal)
        showNewMessageButton.backgroundColor = .gray
        showNewMessageButton.tintColor = .white
        showNewMessageButton.sizeToFit()
        showNewMessageButton.layer.cornerRadius = 10
        showNewMessageButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        var config = UIButton.Configuration.plain()
        let insets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        config.contentInsets = insets
        showNewMessageButton.configuration = config
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleShowNewMessageGesture))
        showNewMessageButton.addGestureRecognizer(tapGesture)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyMessageView.self, forCellReuseIdentifier: "MyMessageCell")
        tableView.register(PeerMessageView.self, forCellReuseIdentifier: "PeerMessageCell")
        tableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    private func addKeyboardObserver() {
    // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            make.leading.trailing.equalToSuperview()
        }
        
        showNewMessageButton.snp.makeConstraints { make in
            make.bottom.equalTo(chatInputView.snp.top).offset(-10)
            make.centerX.equalTo(chatInputView.snp.centerX)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.bottom.equalTo(chatInputView.snp.top).offset(-20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func bind() {
        observe { [weak self] in
            guard let self else { return }
            guard store.chats.count > 0 else { return }
            
            
            let newIndexPath = IndexPath(row: store.chats.count - 1, section: 0)
            self.tableView.insertRows(at: [newIndexPath], with: .bottom)
        }
        
        observe { [weak self] in
            guard let self else { return }
            guard let indexPath = store.indexPathToScroll else { return }
            guard tableView.isValidIndex(indexPath) else {
                store.send(.invalidIndexPathDetected(indexPath: indexPath))
                return
            }
            
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        
        observe { [weak self] in
            guard let self else { return }
            updateShowNewMessageButton()
        }
    }
    
    private func updateShowNewMessageButton() {
        showNewMessageButton.isHidden = store.hasSeenLastRow
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.send(.viewDidAppear)
    }
    
    /// Adjusts the containerView bottom constraint for the keyboard
    private func adjustContainerViewForKeyboard(height: CGFloat, animationDuration: TimeInterval) {
        containerViewBottomConstraint?.constant = -height
        self.view.layoutIfNeeded()
    }
    
    // MARK: TablewView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageState = store.chats[indexPath.row]
        
        if messageState.isMyMessage {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageView
            cell.configure(state: messageState)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeerMessageCell", for: indexPath) as! PeerMessageView
            cell.configure(state: messageState)
            return cell
        }
    }
    
    // MARK: Gestures & Events
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        store.send(.tableViewTapped)
    }
    
    @objc private func handleShowNewMessageGesture(_ gesture: UITapGestureRecognizer) {
        store.send(.showNewMessageTapped(lastIndexPath: tableView.lastIndexPath))
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        adjustContainerViewForKeyboard(height: keyboardHeight, animationDuration: animationDuration)
        
        store.send(.keyboardWillShow)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        adjustContainerViewForKeyboard(height: 0, animationDuration: animationDuration)
        store.send(.keyboardWillHide)
    }
}

#Preview {
    let state = ChatFeature.State(chats: [
        MessageState(text: "Hello", messageSendDate: .now, isMyMessage: true),
        MessageState(text: "World", messageSendDate: .now, isMyMessage: false)
    ])
    
    ChatViewController(store: Store(initialState: state) {
        ChatFeature()
            ._printChanges()
    })
}
