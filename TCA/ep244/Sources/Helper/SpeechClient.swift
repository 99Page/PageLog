//
//  SpeechClient.swift
//  TCA-244
//
//  Created by 노우영 on 9/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Speech
import Dependencies

struct SpeechClient {
    var requestAuthorization: @Sendable () async -> SFSpeechRecognizerAuthorizationStatus
}

extension SpeechClient: DependencyKey {
    static let liveValue: SpeechClient = SpeechClient {
        await withUnsafeContinuation { continuation in
            continuation.resume(with: .success(.authorized))
//            SFSpeechRecognizer.requestAuthorization { status in
//                continuation.resume(with: .success(status))
//            }
        }
    }
    
    static let previewValue = SpeechClient {
        .authorized
    }
}

extension DependencyValues {
    var speechClient: SpeechClient {
        get { self[SpeechClient.self] }
        set { self[SpeechClient.self] = newValue }
    }
}
