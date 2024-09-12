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
    var start: () -> AsyncThrowingStream<String, Error>
}

extension SpeechClient: DependencyKey {
    static var liveValue: SpeechClient {
        previewValue
    }
    
    static var previewValue: SpeechClient {
        SpeechClient {
            .authorized
        } start: {
            AsyncThrowingStream { continuation in
                Task { @MainActor in
                    var finalText = """
                    Lorem ipsum dolor sit amet, consectetur \
                    adipiscing elit, sed do eiusmod tempor \
                    incididunt ut labore et dolore magna aliqua. Ut \
                    enim ad minim veniam, quis nostrud exercitation \
                    ullamco laboris nisi ut aliquip ex ea commodo \
                    consequat. Duis aute irure dolor in \
                    reprehenderit in voluptate velit esse cillum \
                    dolore eu fugiat nulla pariatur. Excepteur sint \
                    occaecat cupidatat non proident, sunt in culpa \
                    qui officia deserunt mollit anim id est laborum.
                    """
                    var text = ""
                    while true {
                        let word = finalText.prefix { $0 != " " }
                        try await Task.sleep(
                            for: .milliseconds(
                                word.count * 50 + .random(in: 0...200)
                            )
                        )
                        finalText.removeFirst(word.count)
                        if finalText.first == " " {
                            finalText.removeFirst()
                        }
                        text += word + " "
                        continuation.yield(text)
                    }
                }
            }
        }
    }
}

extension DependencyValues {
    var speechClient: SpeechClient {
        get { self[SpeechClient.self] }
        set { self[SpeechClient.self] = newValue }
    }
}
