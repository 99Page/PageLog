//
//  ChatInputFeature.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture
import UIKit

@Reducer
struct ChatInputFeature {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let id = UUID()
        var text = ""
        var isEditing = false
        var isSendable = false
        var sendButtonBackgroundColor: UIColor = .gray
        
        var selectedRange = UTF16Offsets(startOffset: 0, endOffset: 0)
        
        /// `text`를 호출하면 항상 `textFieldDidChangeSelection`이 호출됩니다.
        /// 이 경우, Programmatic 하게 텍스트를 변경 후 selectedRange가 제대로 적용되지 않습니다.
        /// 따라서 텍스트 변경이 키보드에 의한 변경인지, 프로그래머틱한 변경인지 구분해야합니다.
        var isTextUpdateByKeyboard = true
    }
    
    enum Action {
        case sendButtonTapped(text: String)
        case textFieldDidChangeSelection(text: String, selectedRange: UTF16Offsets)
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
            case let .textFieldDidChangeSelection(text, selectedRange):
                state.text = text
                state.selectedRange = selectedRange
                updateSendButtonState(state: &state)
                
                return .none
            case .editingStateDidChange(isEditing: let isEditing):
                state.isEditing = isEditing
                return .none
            case .asteriskButtonTapped:
                addAsterisk(state: &state)
                return .send(.textFieldDidChangeSelection(text: state.text, selectedRange: state.selectedRange))
            case .receiveProgrammaticTextUpdate:
                state.isTextUpdateByKeyboard = true
                return .none
            }
        }
    }
    
    private func updateSendButtonState(state: inout State) {
        if state.text.isEmpty {
            state.isSendable = false
            state.sendButtonBackgroundColor = .gray
        } else {
            state.isSendable = true
            state.sendButtonBackgroundColor = UIColor(resource: .reppleyGreen)
        }
    }
    
    private func addAsterisk(state: inout State) {
        let selectedRange = state.selectedRange
        
        let stringIndex = String.Index(utf16Offset: selectedRange.startOffset, in: state.text)
        state.text.insert("*", at: stringIndex)
        
        let newStartOffset = selectedRange.startOffset + 1
        state.selectedRange.startOffset = newStartOffset
        state.selectedRange.endOffset = newStartOffset
        state.isTextUpdateByKeyboard = false
    }
}
