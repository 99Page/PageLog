//
//  ChatInputTests.swift
//  CaseStudies-UIKitTests
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Testing
import ComposableArchitecture
@testable import CaseStudies_UIKit

struct ChatInputTests {
    
    @Test
    func asteriskButtonTapped() async throws {
        let state = ChatInputFeature.State()
        
        let store = await TestStore(initialState: state) {
            ChatInputFeature()
        }
        
        await store.send(.asteriskButtonTapped) {
            $0.text = "*"
        }
    }
    
    @Test
    func asteriskButtonTapped_whenImageAdded() async throws {
        let state = ChatInputFeature.State(text: "❤️", startOffset: 1)
        
        let store = await TestStore(initialState: state) {
            ChatInputFeature()
        }
        
        await store.send(.asteriskButtonTapped) {
            $0.text = "❤️*"
        }
    }

}
