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
        
        /// 텍스트가 편집 전인 경우 nil 값입니다
        var utf16StartOffset: Int?
        var utf16EndOffset: Int?
        
        /// `text`를 호출하면 항상 `textFieldDidChangeSelection`이 호출됩니다.
        /// 이 경우, Programmatic 하게 텍스트를 변경 후 selectedRange가 제대로 적용되지 않습니다.
        /// 따라서 텍스트 변경이 키보드에 의한 변경인지, 프로그래머틱한 변경인지 구분해야합니다.
        var isTextUpdateByKeyboard = true
    }
    
    enum Action {
        case sendButtonTapped(text: String)
        case textFieldDidChangeSelection(text: String, utft16StartOffset: Int, utf16EndOffset: Int) // UIKit은 Binding이 없다. 따라서 BindableAction 같은거 없다!
        case editingStateDidChange(isEditing: Bool)
        case asteriskButtonTapped
        case receiveProgrammaticTextUpdate
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .sendButtonTapped:
                state.text = ""
                return .none
            case let .textFieldDidChangeSelection(text, utf16StartOffset, utf16EndOffset):
                state.text = text
                state.utf16StartOffset = utf16StartOffset
                state.utf16EndOffset = utf16EndOffset
                return .none
            case .editingStateDidChange(isEditing: let isEditing):
                state.isEditing = isEditing
                return .none
            case .asteriskButtonTapped:
                addAsterisk(state: &state)
                return .none
            case .receiveProgrammaticTextUpdate:
                state.isTextUpdateByKeyboard = true
                return .none
            }
        }
    }
    
    private func addAsterisk(state: inout State) {
        guard let utf16StartOffset = state.utf16StartOffset else { return }
        
        let stringIndex = String.Index(utf16Offset: utf16StartOffset, in: state.text)
        state.text.insert("*", at: stringIndex)
        
        state.utf16StartOffset = utf16StartOffset + 1
        state.utf16EndOffset = state.utf16StartOffset
        state.isTextUpdateByKeyboard = false
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
            
            updateText()
            updateSelectedTextRange()
            updateEditingState(self.store.isEditing)
        }
    }
    
    // MARK: Update UITextField by State
    
    private func updateText() {
        inputField.text = "\(self.store.text)"
    }
    
    private func updateEditingState(_ isEditing: Bool) {
        if isEditing {
            inputField.becomeFirstResponder()
        } else {
            inputField.resignFirstResponder()
        }
    }
    
    private func updateSelectedTextRange() {
        guard let startOffset = self.store.utf16StartOffset,
              let endOffset = self.store.utf16EndOffset,
              let start = inputField.position(from: inputField.beginningOfDocument, offset: startOffset),
              let end = inputField.position(from: inputField.beginningOfDocument, offset: endOffset) else {
            return
        }
        
        inputField.selectedTextRange = inputField.textRange(from: start, to: end)
    }
    
    // MARK: Action
    
    @objc func asteriskButtonTapped() {
        store.send(.asteriskButtonTapped)
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
        guard store.isTextUpdateByKeyboard else {
            store.send(.receiveProgrammaticTextUpdate)
            return
        }
        
        guard let selectedRange = textField.selectedTextRange,
              let text = textField.text else {
            return
        }
        
        let utf16StartOffset = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        let utf16EndOffset = textField.offset(from: textField.beginningOfDocument, to: selectedRange.end)
        
        store.send(.textFieldDidChangeSelection(text: text, utft16StartOffset: utf16StartOffset, utf16EndOffset: utf16EndOffset))
    }
}

#Preview {
    let state = ChatInputFeature.State()
    ChatInputView(store: Store(initialState: state) {
        ChatInputFeature()
            ._printChanges()
    })
}
