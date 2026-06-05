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
        setUpShadow()
    }
    
    private func setUpInputField() {
        inputField.delegate = self
        inputField.tintColor = .black
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        inputField.leftView = paddingView
        inputField.leftViewMode = .always
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
        sendButton.tintColor = .white
        sendButton.backgroundColor = UIColor(resource: .reppleyGreen)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    private func setUpShadow() {
        self.backgroundColor = .white
        self.layer.masksToBounds = false // 그림자를 표시하려면 필수
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: -5) // 그림자를 위로 이동
    }
    
    private func setUpConstraints() {
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(60)
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
            
            updateText(store.text)
            updateSendButton()
            updateSelectedTextRange()
        }
        
        observe { [weak self] in
            guard let self else { return }
            updateEditingState(store.isEditing)
        }
    }
    
    // MARK: Update UITextField by State
    
    private func updateText(_ text: String) {
        inputField.text = text
    }
    
    private func updateSendButton() {
        sendButton.isEnabled = store.isSendable
        sendButton.backgroundColor = store.sendButtonBackgroundColor
    }
    
    private func updateEditingState(_ isEditing: Bool) {
        if isEditing {
            inputField.becomeFirstResponder()
        } else {
            inputField.resignFirstResponder()
        }
    }
    
    private func updateSelectedTextRange() {
        let selectedRange = store.selectedRange
        
        guard let start = inputField.position(from: inputField.beginningOfDocument, offset: selectedRange.startOffset),
              let end = inputField.position(from: inputField.beginningOfDocument, offset: selectedRange.endOffset) else {
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
        
        let selectedRangeUTF16 = UTF16Offsets(startOffset: utf16StartOffset, endOffset: utf16EndOffset)
        
        store.send(.textFieldDidChangeSelection(
            text: text,
            selectedRange: selectedRangeUTF16)
        )
    }
}

#Preview {
    let state = ChatInputFeature.State()
    ChatInputView(store: Store(initialState: state) {
        ChatInputFeature()
            ._printChanges()
    })
}
