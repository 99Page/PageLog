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
        
        enum Alert {
            case confirmSave
            case confirmDiscard
        }
        
        enum Delegate {
            case saveMeeting
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .endMeetingButtonTapped:
                state.alert = AlertState {
                    TextState("End meeting?")
                } actions: {
                    ButtonState(action: .confirmSave) {
                        TextState("Save and end")
                    }
                    
                    ButtonState(role: .destructive, action: .confirmDiscard) {
                        TextState("Discard")
                    }
                    
                    ButtonState(role: .cancel) {
                        TextState("Resume")
                    }
                } message: {
                    TextState("You are endting the meeting early. What would you like to do?")
                }
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
                    let status = await self.speechClient.requestAuthorization()
                     
                    for await _ in self.continuousClock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
            case .timerTicked:
                state.secondsElapsed += 1
                let secondPerAttendee = Int(state.standup.durationPerAttendee.components.seconds)
                
                if state.secondsElapsed.isMultiple(of: secondPerAttendee) {
                    if state.speakerIndex == state.standup.attendees.count - 1 {
                        return .run { send in
                            await send(.delegate(.saveMeeting))
                            await self.dismiss()
                        }
                    }
                    
                    state.speakerIndex += 1
                }
                return .none
            case .delegate:
                return .none
            case .alert(.presented(.confirmDiscard)):
                return .run { _ in
                    await self.dismiss()
                }
            case .alert(.presented(.confirmSave)):
                return .run { send in
                    await send(.delegate(.saveMeeting))
                    await self.dismiss()
                }
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
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
