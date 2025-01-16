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
    }
    
    enum Action {
        case sendButtonTapped(text: String)
        case textDidChange(text: String) // UIKit은 Binding이 없다. 따라서 BindableAction 같은거 없다!
        case editingStateDidChange(isEditing: Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .sendButtonTapped:
                state.text = ""
                return .none
            case let .textDidChange(text):
                state.text = text
                return .none
            case .editingStateDidChange(isEditing: let isEditing):
                state.isEditing = isEditing
                return .none
            }
        }
    }
}

class ChatInputView: UIView, UITextFieldDelegate {
    private let inputField = UITextField()
    private let sendButton = UIButton(type: .custom)
    
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
        addSubview(sendButton)
        
        setUpInputField()
        setUpSendButton()
    }
    
    private func setUpInputField() {
        inputField.placeholder = "Input text here!"
        inputField.delegate = self
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
        
        inputField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading)
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        store.send(.textDidChange(text: textField.text ?? ""))
    }
    
    @objc func sendButtonTapped() {
        store.send(.sendButtonTapped(text: inputField.text ?? ""))
    }
    
    
}

#Preview {
    let state = ChatInputFeature.State()
    ChatInputView(store: Store(initialState: state) {
        ChatInputFeature()
            ._printChanges()
    })
}
