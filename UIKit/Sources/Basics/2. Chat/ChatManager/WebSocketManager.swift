//
//  WebSocketManager.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import Starscream
import Combine

class WebSocketManager: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        
    }
    
    private var socket: WebSocket!
    private let serverURL = URL(string: "wss://echo.websocket.events")!
    private let messageSubject = PassthroughSubject<String, Never>()

    init() {
        var request = URLRequest(url: serverURL)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func send(message: String) {
        socket.write(string: message)
        debugPrint("send!")
    }

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            print("WebSocket connected")
        case .disconnected(let reason, let code):
            print("WebSocket disconnected. Reason: \(reason), Code: \(code)")
        case .text(let string):
            debugPrint("receive text: \(string)")
            messageSubject.send(string)
        case .error(let error):
            print("WebSocket error: \(String(describing: error))")
        default:
            break
        }
    }

    var receiveMessages: AnyPublisher<String, Never> {
        messageSubject.eraseToAnyPublisher()
    }
}
