//
//  ChatFeature.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture
import UIKit

@Reducer
struct ChatFeature {
    @ObservableState
    struct State: Equatable {
        var chats: IdentifiedArrayOf<MessageState> = []
        var chatInput = ChatInputFeature.State()
        
        var lastVisibleIndexPath: IndexPath?
        var indexPathToScroll: IndexPath?
        
        var hasSeenLastRow = true
        var isScrolledToBottom = false
        
        var isLastRowUnseen: Bool { !hasSeenLastRow }
        
        var isScrollPositionAboveBottom: Bool { !isScrolledToBottom }
        
        var indexSettingRetryCounts: [IndexPath: Int] = [:]
        let maxIndexSettingRetry = 2
        
        mutating func updateIndexPathToScroll() {
            indexPathToScroll = lastVisibleIndexPath
        }
        
        func canRetry(for indexPath: IndexPath) -> Bool {
            let retryCount = indexSettingRetryCounts[indexPath] ?? 0
            return retryCount < maxIndexSettingRetry
        }
    }
    
    enum Action {
        case chatInput(ChatInputFeature.Action)
        case viewDidAppear
        case messageReceived(Result<ChatClient.Message, any Error>)
        case tableViewTapped
        case scrollDetected(lastVisibleIndexPath: IndexPath?, isScrolledToBottom: Bool)
        case showNewMessageTapped(lastIndexPath: IndexPath?)
        case keyboardWillShow
        case keyboardWillHide
        case updateIndexPath(indexPath: IndexPath)
        case invalidIndexPathDetected(indexPath: IndexPath)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.chatClient) var chatClient
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.chatInput, action: \.chatInput) {
            ChatInputFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .chatInput(action):
                switch action {
                case let .sendButtonTapped(text):
                    guard text.hasValue else { return .none }
                    
                    let newChat = MessageState(text: text, messageSendDate: .now, isMyMessage: true)
                    
                    if state.isScrollPositionAboveBottom {
                        state.hasSeenLastRow = false
                    }
                    
                    state.chats.append(newChat)
                    
                    let isScrolledToBottom = state.isScrolledToBottom
                    let newIndexPath = IndexPath(row: state.chats.count - 1, section: 0)
                    
                    return .run { send in
                        try await self.chatClient.send(ChatClient.ID(), .string(text))
                        guard isScrolledToBottom else { return }
                        await send(.updateIndexPath(indexPath: newIndexPath))
                    }
                default:
                    return .none
                }
            case .viewDidAppear:
                return .run { send in
                    await addWebSocketAsyncStream(send)
                }
            case .messageReceived(.failure):
                return .none
            case let .messageReceived(.success(message)):
                if case let .string(string) = message {
                    let newChat = MessageState(text: string, messageSendDate: .now, isMyMessage: false)
                    
                    if state.isScrollPositionAboveBottom {
                        state.hasSeenLastRow = false
                    }
                    
                    
                    state.chats.append(newChat)
                    
                    let newIndexPath = IndexPath(row: state.chats.count - 1, section: 0)
                    
                    if state.isScrolledToBottom {
                        return .send(.updateIndexPath(indexPath: newIndexPath))
                    }
                }
                return .none
            case .tableViewTapped:
                state.chatInput.isEditing = false
                return .none
            case let .scrollDetected(lastVisibleIndexPath, hasSeenLastRow):
                state.lastVisibleIndexPath = lastVisibleIndexPath
                
                /// `||` 연산을 사용할 경우 에러가 발생합니다.
                if state.isLastRowUnseen {
                    state.hasSeenLastRow = hasSeenLastRow
                }
                
                state.isScrolledToBottom = hasSeenLastRow
                
                return .none
            case let .showNewMessageTapped(lastIndexPath):
                state.indexPathToScroll = lastIndexPath
                return .none
            case .keyboardWillShow, .keyboardWillHide:
                state.updateIndexPathToScroll()
                return .none
            case let .updateIndexPath(indexPath):
                state.indexPathToScroll = indexPath
                return .none
            case let .invalidIndexPathDetected(indexPath):
                let value = state.indexSettingRetryCounts[indexPath] ?? 0
                
                guard state.canRetry(for: indexPath) else {
                    state.indexSettingRetryCounts[indexPath] = 0
                    return .none
                }
                
                state.indexSettingRetryCounts[indexPath] = value + 1
                state.indexPathToScroll = nil
                
                return .run { send in
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    await send(.updateIndexPath(indexPath: indexPath))
                }
            }
        }
    }
    
    
    private func addWebSocketAsyncStream(_ send: Send<Action>) async {
        let actions = await self.chatClient.open(
            ChatClient.ID(),
            URL(string: "wss://echo.websocket.events")!,
            []
        )
        
        await withThrowingTaskGroup(of: Void.self) { group in
            /// actions는 AsyncStream 타입이다.
            /// AsyncStream은 for문과 함께 쓰이면서, Stream으로 받아온 데이터들을 하나씩 처리할 수 있다.
            /// .finish가 호출되기 전까지 아래 for문은 계속 유지된다.
            for await action in actions {
                await handleChatClientAction(action: action, group: &group, send: send)
            }
        }
    }
    
    private func handleChatClientAction(
        action: ChatClient.Action,
        group: inout ThrowingTaskGroup<Void, any Error>,
        send: Send<Action>
    ) async {
        /// `Effect.{task,run}`에서 태스크 로컬 의존성이 변경되기때문에
        /// `group.addTask` 바깥에서 `await send`를 호출할 수 없습니다.
        switch action {
        case .didOpen:
            group.addTask {
                while !Task.isCancelled {
                    try await self.clock.sleep(for: .seconds(10))
                    try? await self.chatClient.sendPing(ChatClient.ID())
                }
            }
            
            group.addTask {
                /// receive로 받아온 값도 AsyncStream 타입입니다.
                /// 따라서 .finish 호출 전까지 계속 for문이 유지됩니다.
                for await result in try await self.chatClient.receive(ChatClient.ID()) {
                    await send(.messageReceived(result))
                }
            }
        case .didClose:
            return
        }
    }
}
