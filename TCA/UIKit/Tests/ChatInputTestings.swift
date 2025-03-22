//
//  ChatInputTestings.swift
//  CaseStudies-UIKitTests
//
//  Created by 노우영 on 1/21/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Testing
import ComposableArchitecture
import SwiftUI
@testable import CaseStudies_UIKit

struct ChatInputTestings {
    
    struct TestArgument {
        let text: String
        let leadingText: String
        let expectedText: String
        
        static var cases: [TestArgument] {
            [
                TestArgument(text: "Hello, 👋", leadingText: "Hell", expectedText: "Hell*o, 👋"),
                TestArgument(text: "👋👋👋👋", leadingText: "👋👋", expectedText: "👋👋*👋👋"),
                TestArgument(text: "", leadingText: "", expectedText: "*")
            ]
        }
    }
    
    @Test(arguments: TestArgument.cases)
    func asteriskButtonTapped(_ argument: TestArgument) async throws {
        
        let offset = argument.leadingText.utf16.count
        let utft16Offsets = UTF16Offsets(startOffset: offset, endOffset: offset)
        let state = ChatInputFeature.State(text: argument.text, selectedRange: utft16Offsets)
        
        let store = await TestStore(initialState: state) {
            ChatInputFeature()
        }
        
        await store.send(.asteriskButtonTapped) {
            let asteriskCount = "*".utf16.count
            let newOffset = offset + asteriskCount
            $0.text = argument.expectedText
            $0.selectedRange = UTF16Offsets(startOffset: newOffset, endOffset: newOffset)
            $0.isTextUpdateByKeyboard = false
        }
        
        await store.receive(\.textFieldDidChangeSelection) {
            $0.isSendable = true
            $0.sendButtonBackgroundColor = UIColor(resource: .reppleyGreen)
        }
    }

    @Test
    func sendButtonTapped() async {
        let text = "Hello"
        let state = ChatInputFeature.State(text: text)
        let store = await TestStore(initialState: state) {
            ChatInputFeature()
        }
        
        await store.send(.sendButtonTapped(text: text)) {
            $0.text = ""
        }
    }
}
