//
//  ChatFeature.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChatFeature {
    @ObservableState
    struct State: Equatable {
        var chats: IdentifiedArrayOf<MessageState> = []
        var chatInput = ChatInputFeature.State()
    }
    
    enum Action {
        case chatInput(ChatInputFeature.Action)
        case viewDidAppear
        case receivedMessage(Result<WebSocketClient.Message, any Error>)
        case scrollTapped
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.webSocket) var webSocket
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.chatInput, action: \.chatInput) {
            ChatInputFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .chatInput(action):
                switch action {
                case let .sendButtonTapped(text):
                    guard !text.isEmpty else { return .none }
                    let newChat = MessageState(text: text, messageSendDate: .now, isMyMessage: true)
                    state.chats.append(newChat)
                    
                    return .run { send in
                        try await self.webSocket.send(WebSocketClient.ID(), .string(text))
                    }
                default:
                    return .none
                }
            case .viewDidAppear:
                return .run { send in
                    let actions = await self.webSocket.open(
                        WebSocketClient.ID(),
                        URL(string: "wss://echo.websocket.events")!,
                        []
                    )
                    
                    await withThrowingTaskGroup(of: Void.self) { group in
                        for await action in actions {
                            // NB: Can't call `await send` here outside of `group.addTask` due to task local
                            //     dependency mutation in `Effect.{task,run}`. Can maybe remove that explicit task
                            //     local mutation (and this `addTask`?) in a world with
                            //     `Effect(operation: .run { ... })`?
                            switch action {
                            case .didOpen:
                                group.addTask {
                                    while !Task.isCancelled {
                                        try await self.clock.sleep(for: .seconds(10))
                                        try? await self.webSocket.sendPing(WebSocketClient.ID())
                                    }
                                }
                                group.addTask {
                                    for await result in try await self.webSocket.receive(WebSocketClient.ID()) {
                                        await send(.receivedMessage(result))
                                    }
                                }
                            case .didClose:
                                return
                            }
                        }
                    }
                }
            case .receivedMessage(.failure):
                return .none
            case let .receivedMessage(.success(message)):
                if case let .string(string) = message {
                    let newChat = MessageState(text: string, messageSendDate: .now, isMyMessage: false)
                    state.chats.append(newChat)
                }
                return .none
            case .scrollTapped:
                state.chatInput.isEditing = false
                return .none
            }
        }
    }
}
