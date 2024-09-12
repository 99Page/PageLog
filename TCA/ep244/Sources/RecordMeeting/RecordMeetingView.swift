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
        @PresentationState var alert: AlertState<Action.Alert>?
        var secondsElapsed = 0
        var speakerIndex = 0
        let standup: Standup
        var transcript = ""
        
        init(standup: Standup) {
            self.standup = standup
        }
        
        var durationRemaining: Duration {
            self.standup.duration - .seconds(self.secondsElapsed)
        }
    }
    
    @Dependency(\.continuousClock) var continuousClock
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.speechClient) var speechClient
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case endMeetingButtonTapped
        case nextButtonTapped
        case onTask
        case timerTicked
        case speechResult(transcript: String)
        
        enum Alert {
            case confirmSave
            case confirmDiscard
        }
        
        enum Delegate: Equatable {
            case saveMeeting(transcript: String)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .endMeetingButtonTapped:
                state.alert = .endMeeting(isDiscardable: true)
                return .none
            case .nextButtonTapped:
                guard state.speakerIndex < state.standup.attendees.count - 1 else {
                    state.alert = AlertState {
                        TextState("End meeting?")
                    } actions: {
                        ButtonState(action: .confirmSave) {
                            TextState("Save and end")
                        }
                        
                        ButtonState(role: .cancel) {
                            TextState("Resume")
                        }
                    } message: {
                        TextState("You are endting the meeting early. What would you like to do?")
                    }
                    return .none
                }
                
                state.speakerIndex += 1
                state.secondsElapsed = state.speakerIndex * Int(state.standup.durationPerAttendee.components.seconds)
                
                return .none
            case .onTask:
                return .run { send in
                    /// 내부가 길어지면 함수로 빼낸다.
                    /// case를 추가할 줄 알았는데 그건 아니다 
                    await onTask(send: send)
                }
            case .timerTicked:
                guard state.alert == nil 
                else { return .none }
                
                state.secondsElapsed += 1
                let secondPerAttendee = Int(state.standup.durationPerAttendee.components.seconds)
                
                if state.secondsElapsed.isMultiple(of: secondPerAttendee) {
                    if state.speakerIndex == state.standup.attendees.count - 1 {
                        /// capture 필요하면 아래 코드 참고
                        return .run { [transcript = state.transcript] send in
                            let saveMeeting: Action.Delegate = .saveMeeting(transcript: transcript)
                            await send(.delegate(saveMeeting))
                            await self.dismiss()
                        }
                    }
                    
                    state.speakerIndex += 1
                }
                return .none
            case .delegate:
                return .none
            case .alert(.presented(.confirmDiscard)):
                return .run { send in
                    await self.dismiss()
                }
            case .alert(.presented(.confirmSave)):
                return .run { [transcript = state.transcript] send in
                    let saveMeeting: Action.Delegate = .saveMeeting(transcript: transcript)
                    await send(.delegate(saveMeeting))
                    await self.dismiss()
                }
            case .alert(.dismiss):
                return .none
            case let .speechResult(transcript):
                state.transcript = transcript
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    private func onTask(send: Send<Action>) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                let status = await self.speechClient.requestAuthorization()
                
                if status == .authorized {
                    do {
                        for try await trascript in self.speechClient.start() {
                            await send(.speechResult(transcript: trascript))
                        }
                    } catch {
                        // TODO: Handle error
                    }
                }
            }
            
            group.addTask {
                for await _ in self.continuousClock.timer(interval: .seconds(1)) {
                    await send(.timerTicked)
                }
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
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
        }
    }
}

#Preview {
    NavigationStack {
        RecordMeetingView(store: Store(initialState: RecordMeetingFeature.State(standup: .mock), reducer: {
            RecordMeetingFeature()
        }))
    }
}


extension AlertState where Action == RecordMeetingFeature.Action.Alert {
    static func endMeeting(isDiscardable: Bool) -> AlertState {
        AlertState {
            TextState("End meeting?")
        } actions: {
            ButtonState(action: .confirmSave) {
                TextState("Save and end")
            }
            
            if isDiscardable {
                ButtonState(role: .destructive, action: .confirmDiscard) {
                    TextState("Discard")
                }
            }
            
            ButtonState(role: .cancel) {
                TextState("Resume")
            }
        } message: {
            TextState("You are endting the meeting early. What would you like to do?")
        }
    }
}
