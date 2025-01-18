//
//  ChatBubbleState.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import IdentifiedCollections

struct MessageState: Equatable, Identifiable {
    let id = UUID()
    let text: String
    let messageSendDate: Date
    let isMyMessage: Bool
    
    let dateViewOffset: CGFloat = 30
    let messageViewOffset: CGFloat = 10
    let backgroundCornerRadius: CGFloat = 10
    
    static var stubs: IdentifiedArrayOf<MessageState> {
        [
            MessageState(
                text: "Imagine there's no heaven. It's easy if you tryNo hell below us Above us, only sky Imagine all the people Living for today",
                messageSendDate: .now,
                isMyMessage: true
            ),
            MessageState(
                text: "Imagine there's no heaven. It's easy if you tryNo hell below us Above us, only sky Imagine all the people Living for today",
                messageSendDate: .now,
                isMyMessage: false
            ),
            MessageState(text: "World1", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello2", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World2", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello3", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World3", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello4", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World4", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello5", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World5", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello6", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World6", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello7", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World7", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello8", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World8", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello9", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World9", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello10", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World10", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello11", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World11", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello12", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World12", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello13", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World13", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello14", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World14", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello15", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World15", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello16", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World16", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello17", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World17", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello18", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World18", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello19", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World19", messageSendDate: .now, isMyMessage: false),
            MessageState(text: "Hello20", messageSendDate: .now, isMyMessage: true),
            MessageState(text: "World20", messageSendDate: .now, isMyMessage: false),
            
        ]
    }
}
