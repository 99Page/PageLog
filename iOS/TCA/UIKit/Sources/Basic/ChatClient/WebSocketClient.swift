//
//  WebSocketClient.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct ChatClient {
    struct ID: Hashable, @unchecked Sendable {
        let rawValue: AnyHashable
        
        init<RawValue: Hashable & Sendable>(_ rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        init() {
            struct RawValue: Hashable, Sendable {}
            self.rawValue = RawValue()
        }
    }
    
    @CasePathable
    enum Action {
        case didOpen(protocol: String?)
        case didClose(code: URLSessionWebSocketTask.CloseCode, reason: Data?)
    }
    
    @CasePathable
    enum Message: Equatable {
        struct Unknown: Error {}
        
        case data(Data)
        case string(String)
        
        init(_ message: URLSessionWebSocketTask.Message) throws {
            switch message {
            case let .data(data): self = .data(data)
            case let .string(string): self = .string(string)
            @unknown default: throw Unknown()
            }
        }
    }
    
    var open: @Sendable (_ id: ID, _ url: URL, _ protocols: [String]) async -> AsyncStream<Action> = {
        _, _, _ in .finished
    }
    var receive: @Sendable (_ id: ID) async throws -> AsyncStream<Result<Message, any Error>>
    var send: @Sendable (_ id: ID, _ message: URLSessionWebSocketTask.Message) async throws -> Void
    var sendPing: @Sendable (_ id: ID) async throws -> Void
}

extension ChatClient: DependencyKey {
    static var liveValue: Self {
        return Self(
            open: { await WebSocketActor.shared.open(id: $0, url: $1, protocols: $2) },
            receive: { try await WebSocketActor.shared.receive(id: $0) },
            send: { try await WebSocketActor.shared.send(id: $0, message: $1) },
            sendPing: { try await WebSocketActor.shared.sendPing(id: $0) }
        )
        
        @globalActor final actor WebSocketActor {
            
            /// Sendable 타입은 쓰레드 안정성을 보장해야합니다.
            /// @unchecked를 선언해서, 개발자가 쓰레드 안정성을 보장한다고 컴파일러에게 알려줄 수 있습니다.
            /// 사용 방식만 보면 그다지 안전하지는 않은 방식입니다.
            private final class Delegate: NSObject, @unchecked Sendable, URLSessionWebSocketDelegate {
                
                /// Socket의 open, close를 전달.
                /// 메세지 전달과는 무관하다
                var continuation: AsyncStream<Action>.Continuation?
                
                nonisolated func urlSession(
                    _: URLSession,
                    webSocketTask _: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?
                ) {
                    self.continuation?.yield(.didOpen(protocol: `protocol`))
                }
                
                nonisolated func urlSession(
                    _: URLSession,
                    webSocketTask _: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?
                ) {
                    self.continuation?.yield(.didClose(code: closeCode, reason: reason))
                    self.continuation?.finish()
                }
            }
            
            typealias Dependencies = (socket: URLSessionWebSocketTask, delegate: Delegate)
            
            static let shared = WebSocketActor()
            
            var dependencies: [ID: Dependencies] = [:]
            
            func open(id: ID, url: URL, protocols: [String]) -> AsyncStream<Action> {
                let delegate = Delegate()
                let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
                let socket = session.webSocketTask(with: url, protocols: protocols)
                defer { socket.resume() }
                var continuation: AsyncStream<Action>.Continuation!
                let stream = AsyncStream<Action> {
                    $0.onTermination = { _ in
                        socket.cancel()
                        Task { await self.removeDependencies(id: id) }
                    }
                    continuation = $0
                }
                
                /// open 때 사용했던 continuation을 저장하고, close할 때 재사용합니다.
                delegate.continuation = continuation
                self.dependencies[id] = (socket, delegate)
                
                return stream
            }
            
            func close(
                id: ID, with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?
            ) async throws {
                defer { self.dependencies[id] = nil }
                try self.socket(id: id).cancel(with: closeCode, reason: reason)
            }
            
            func receive(id: ID) throws -> AsyncStream<Result<Message, any Error>> {
                let socket = try self.socket(id: id)
                
                /// open, close에 사용했던 AsyncStream과는 별개로,
                /// 서버에서 받은 message를 전달하는 용도로 사용합니다.
                return AsyncStream { continuation in
                    let task = Task {
                        while !Task.isCancelled {
                            do {
                                let socketMessage = try await Message(socket.receive())
                                continuation.yield(.success(socketMessage))
                            } catch {
                                continuation.yield(.failure(error))
                            }
                        }
                        continuation.finish()
                    }
                    continuation.onTermination = { _ in task.cancel() }
                }
            }
            
            func send(id: ID, message: URLSessionWebSocketTask.Message) async throws {
                try await self.socket(id: id).send(message)
            }
            
            func sendPing(id: ID) async throws {
                let socket = try self.socket(id: id)
                return try await withCheckedThrowingContinuation { continuation in
                    socket.sendPing { error in
                        if let error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume()
                        }
                    }
                }
            }
            
            private func socket(id: ID) throws -> URLSessionWebSocketTask {
                guard let dependencies = self.dependencies[id]?.socket else {
                    struct Closed: Error {}
                    throw Closed()
                }
                return dependencies
            }
            
            private func removeDependencies(id: ID) {
                self.dependencies[id] = nil
            }
        }
    }
}

extension DependencyValues {
    var chatClient: ChatClient {
        get { self[ChatClient.self] }
        set { self[ChatClient.self] = newValue }
    }
}
