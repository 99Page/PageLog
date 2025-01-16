//
//  ChatManager.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import Dependencies
import Starscream
import Combine

struct ChatClient {
    var sendMessage: @Sendable (String) -> ()
    var connect: @Sendable () -> ()
    var disconnect: @Sendable () -> ()
    var recieveMessages: AnyPublisher<String, Never>
}

extension ChatClient: DependencyKey {
    static var liveValue: ChatClient {
        let manager = WebSocketManager()
        
        return ChatClient(sendMessage: { message in
            manager.send(message: message)
        }, connect: {
            manager.connect()
        }, disconnect: {
            manager.disconnect()
        }, recieveMessages: manager.receiveMessages)
    }
}

extension DependencyValues {
    var chatClient: ChatClient {
        get { self[ChatClient.self] }
        set { self[ChatClient.self] = newValue }
    }
}
