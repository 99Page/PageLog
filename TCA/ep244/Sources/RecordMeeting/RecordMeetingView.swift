//
//  RecordMeeting.swift
//  TCA-244
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Speech

@Reducer
struct RecordMeetingFeature {
    struct State: Equatable {
        var secondsElapsed = 0
        let speakerIndex = 0
        let standup: Standup
        
        init(standup: Standup) {
            self.standup = standup
        }
        
        var durationRemaining: Duration {
            self.standup.duration - .seconds(self.secondsElapsed)
        }
    }
    
    @Dependency(\.continuousClock) var continuousClock
    
    enum Action: Equatable {
        case endMeetingButtonTapped
        case nextButtonTapped
        case onTask
        case timerTicked
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .endMeetingButtonTapped:
                
                return .none
            case .nextButtonTapped:
                return .none
            case .onTask:
                return .run { send in
//                    let status = await withUnsafeContinuation { continuation in
//                        SFSpeechRecognizer.requestAuthorization { status in
//                            continuation.resume(with: .success(status))
//                        }
//                    }
//                    
                    for await _ in self.continuousClock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
            case .timerTicked:
                state.secondsElapsed += 1
                return .none
            }
        }
    }
}

struct RecordMeetingView: View {
    let store: StoreOf<RecordMeetingFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(viewStore.standup.theme.mainColor)
                
                VStack {
                    MeetingHeaderView(
                        secondsElapsed: viewStore.secondsElapsed,
                        durationRemaining: viewStore.durationRemaining,
                        theme: viewStore.standup.theme
                    )
                    
                    MeetingTimerView(
                        standup: viewStore.standup,
                        speakerIndex: viewStore.speakerIndex
                    )
                    
                    MeetingFooterView(
                        standup: viewStore.standup,
                        nextButtonTapped: {
                            viewStore.send(.nextButtonTapped)
                        },
                        speakerIndex: viewStore.speakerIndex
                    )
                }
            }
            .padding()
            .foregroundStyle(viewStore.standup.theme.accentColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("End action") {
                        viewStore.send(.endMeetingButtonTapped)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .task {
                viewStore.send(.onTask)
            }
        }
    }
}
