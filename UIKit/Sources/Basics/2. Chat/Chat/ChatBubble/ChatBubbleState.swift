//
//  ChatBubbleState.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct ChatBubbleState: Equatable, Identifiable {
    let id = UUID()
    let text: String
    let sendDate: Date
    let isMyMessage: Bool
    
    static var stubs: [ChatBubbleState] {
        [
            ChatBubbleState(text: "Hello1", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World1", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello2", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World2", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello3", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World3", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello4", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World4", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello5", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World5", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello6", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World6", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello7", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World7", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello8", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World8", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello9", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World9", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello10", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World10", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello11", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World11", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello12", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World12", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello13", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World13", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello14", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World14", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello15", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World15", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello16", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World16", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello17", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World17", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello18", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World18", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello19", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World19", sendDate: .now, isMyMessage: false),
            ChatBubbleState(text: "Hello20", sendDate: .now, isMyMessage: true),
            ChatBubbleState(text: "World20", sendDate: .now, isMyMessage: false),
            
        ]
    }
}
