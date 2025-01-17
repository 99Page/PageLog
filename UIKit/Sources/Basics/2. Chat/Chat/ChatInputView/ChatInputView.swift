//
//  ChatInputView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import ComposableArchitecture
import SwiftUI

@Reducer
struct ChatInputFeature {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
        var text = ""
        var isEditing = false
        var startOffset = 0
    }
    
    enum Action {
        case sendButtonTapped(text: String)
        case textFieldDidChangeSelection(text: String, startOffset: Int) // UIKit은 Binding이 없다. 따라서 BindableAction 같은거 없다!
        case editingStateDidChange(isEditing: Bool)
        case asterinkButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .sendButtonTapped:
                state.text = ""
                return .none
            case let .textFieldDidChangeSelection(text, startOffset):
                state.text = text
                state.startOffset = startOffset
                return .none
            case .editingStateDidChange(isEditing: let isEditing):
                state.isEditing = isEditing
                return .none
            case .asterinkButtonTapped:
                let startIndex = state.text.startIndex
                let offset = state.text.index(startIndex, offsetBy: state.startOffset)
                state.text.insert("*", at: offset)
                return .none
            }
        }
    }
}

class ChatInputView: UIView, UITextFieldDelegate {
    private let inputField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private let asteriskButton = UIButton(type: .custom)
    
    var store: StoreOf<ChatInputFeature>
    
    init(store: StoreOf<ChatInputFeature>) {
        self.store = store
        super.init(frame: .zero)
        setUpView()
        setUpConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(inputField)
        addSubview(asteriskButton)
        addSubview(sendButton)
        
        setUpInputField()
        setUpAsteriskButton()
        setUpSendButton()
    }
    
    private func setUpInputField() {
        inputField.placeholder = "Input text here!"
        inputField.delegate = self
        inputField.tintColor = .black
    }
    
    private func setUpAsteriskButton() {
        let image = UIImage(systemName: "asterisk")
        image?.withRenderingMode(.alwaysTemplate)
        
        asteriskButton.setImage(image, for: .normal)
        asteriskButton.tintColor = .gray
        asteriskButton.backgroundColor = .clear
        asteriskButton.addTarget(self, action: #selector(asteriskButtonTapped), for: .touchUpInside)
    }
    
    private func setUpSendButton() {
        sendButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        sendButton.backgroundColor = .gray
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(40)
            make.top.bottom.equalToSuperview()
        }
        
        asteriskButton.snp.makeConstraints { make in
            make.trailing.equalTo(sendButton.snp.leading)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        inputField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(asteriskButton.snp.leading)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        observe { [weak self] in
            guard let self else { return }
            
            inputField.text = "\(self.store.text)"
            
            if self.store.isEditing {
                inputField.becomeFirstResponder()
            } else {
                inputField.resignFirstResponder()
            }
        }
    }
    
    // MARK: Action
    
    @objc func asteriskButtonTapped() {
        store.send(.asterinkButtonTapped)
    }
    
    @objc func sendButtonTapped() {
        store.send(.sendButtonTapped(text: inputField.text ?? ""))
    }
    
    // MARK: Text Delegate
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        store.send(.editingStateDidChange(isEditing: true))
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        store.send(.editingStateDidChange(isEditing: false))
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let selectedRange = textField.selectedTextRange else { return }
        guard let text = textField.text else { return }
        
        let startOffset = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        store.send(.textFieldDidChangeSelection(text: text, startOffset: startOffset))
    }
}

#Preview {
    let state = ChatInputFeature.State()
    ChatInputView(store: Store(initialState: state) {
        ChatInputFeature()
            ._printChanges()
    })
}
