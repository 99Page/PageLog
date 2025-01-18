//
//  ChatBubbleState.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct ChatState: Equatable, Identifiable {
    let id = UUID()
    let text: String
    let sendDate: Date
    let isMyMessage: Bool
    
    static var stubs: [ChatState] {
        [
            ChatState(text: "Hello1", sendDate: .now, isMyMessage: true),
            ChatState(text: "World1", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello2", sendDate: .now, isMyMessage: true),
            ChatState(text: "World2", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello3", sendDate: .now, isMyMessage: true),
            ChatState(text: "World3", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello4", sendDate: .now, isMyMessage: true),
            ChatState(text: "World4", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello5", sendDate: .now, isMyMessage: true),
            ChatState(text: "World5", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello6", sendDate: .now, isMyMessage: true),
            ChatState(text: "World6", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello7", sendDate: .now, isMyMessage: true),
            ChatState(text: "World7", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello8", sendDate: .now, isMyMessage: true),
            ChatState(text: "World8", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello9", sendDate: .now, isMyMessage: true),
            ChatState(text: "World9", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello10", sendDate: .now, isMyMessage: true),
            ChatState(text: "World10", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello11", sendDate: .now, isMyMessage: true),
            ChatState(text: "World11", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello12", sendDate: .now, isMyMessage: true),
            ChatState(text: "World12", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello13", sendDate: .now, isMyMessage: true),
            ChatState(text: "World13", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello14", sendDate: .now, isMyMessage: true),
            ChatState(text: "World14", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello15", sendDate: .now, isMyMessage: true),
            ChatState(text: "World15", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello16", sendDate: .now, isMyMessage: true),
            ChatState(text: "World16", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello17", sendDate: .now, isMyMessage: true),
            ChatState(text: "World17", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello18", sendDate: .now, isMyMessage: true),
            ChatState(text: "World18", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello19", sendDate: .now, isMyMessage: true),
            ChatState(text: "World19", sendDate: .now, isMyMessage: false),
            ChatState(text: "Hello20", sendDate: .now, isMyMessage: true),
            ChatState(text: "World20", sendDate: .now, isMyMessage: false),
            
        ]
    }
}
