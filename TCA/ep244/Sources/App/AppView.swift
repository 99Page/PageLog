//
//  AppView.swift
//  TCA-244
//
//  Created by 노우영 on 8/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI


@Reducer
struct AppFeature {
    struct State: Equatable {
        var path = StackState<Path.State>()
        var standupList = StandupsListFeature.State()
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case standupList(StandupsListFeature.Action)
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.date.now) var date
    
    @Reducer
    struct Path {
        enum State: Equatable {
            case detail(StandupDetailFeature.State)
            case recordMeeting(RecordMeetingFeature.State)
            /// meeting view는 reducer가 없으니 위의 두 가지 케이스처럼 state를 갖지 않는다.
            case meeting(meeting: Meeting, standup: Standup)
        }
        
        enum Action: Equatable {
            case detail(StandupDetailFeature.Action)
            case recordMeeting(RecordMeetingFeature.Action)
            
            /// meeting view는 reducer를 갖지 않으니 Action을 가질 필요가 없다.
            case meeting
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                StandupDetailFeature()
            }
            
            Scope(state: \.recordMeeting, action: \.recordMeeting) {
                RecordMeetingFeature()
            }
        }
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Scope(state: \.standupList, action: \.standupList) {
            StandupsListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .path(.element(id: _, action: .detail(.delegate(action)))):
                switch action {
                case let .standupUpdate(standup):
                    state.standupList.standups[id: standup.id] = standup
                    return .none
                case let .deleteStandup(id):
                    state.standupList.standups.remove(id: id)
                    return .none
                }
                // 아래 방식처럼 할 수도 있는데, delegate 방식으로 변경됐다.
//            case let .path(.popFrom(id: id)):
//                /// 내가 고민했던 Sibling끼리의 데이터 업데이트 상황에 대한 TCA의 해결책.
//                /// StackView가 모든 상태를 알고 있으니
//                /// pop됐을 때 여기서 상태를 업데이트해서 반영할 수 있다.
//                /// 이 아이디어를 Vanila Swift에서도 적용해볼만 할 것 같다.
//                ///
//                /// Sibling 업데이트는 Stack에서 관리하자.
//                guard case let .some(.detail(detailState)) = state.path[id: id]
//                else { return .none }
//                
//                let detailStandupId = detailState.standup.id
//                state.standupList.standups[id: detailStandupId] = detailState.standup
//                return .none
            case let .path(.element(id: id, action: .recordMeeting(.delegate(action)))):
                switch action {
                case let .saveMeeting(transcript):
                    guard let detailId = state.path.ids.dropLast().last else {
                        XCTFail("Record meeting is the last element in the stack. A detail feature should proceed it.")
                        return .none
                    }
                    
                    let newMeeting = Meeting(
                        id: self.uuid(),
                        date: self.date,
                        transcript: transcript
                    )
                    
                    state.path[id: detailId, case: \.detail]?.standup.meetings.insert(newMeeting, at: 0)
                    
                    guard let standup = state.path[id: detailId, case: \.detail]?.standup
                    else { return .none }
                    
                    state.standupList.standups[id: standup.id ] = standup
                    
                    return .none
                }
            case .path:
                return .none
            case .standupList(_):
                return .none
            }
        }
        /// optional을 사용했을 때는 ifLet을 사용했다.
        /// stack을 다룰 때는 forEach를 사용한다.
        /// $ 사용 안하니 주의하자.
        .forEach(\.path, action: \.path) {
            Path()
        }
        
        Reduce { state, _ in
                .run { [standups = state.standupList.standups] _ in
                    enum CancelID { case saveDebounce }
                    try await withTaskCancellation(id: CancelID.saveDebounce, cancelInFlight: true) {
                        try await self.clock.sleep(for: .seconds(1))
                        try JSONEncoder().encode(standups).write(to: .standups)
                    }
                }
        }
        
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            StandupsListView(
                store: store.scope(state: \.standupList, action: \.standupList)
            )
        } destination: { state in
            switch state {
            case .detail:
                CaseLet(\AppFeature.Path.State.detail, action: AppFeature.Path.Action.detail) { store in
                    StandupDetailView(store: store)
                }
            case .recordMeeting:
                CaseLet(\AppFeature.Path.State.recordMeeting, action: AppFeature.Path.Action.recordMeeting) { store in
                    RecordMeetingView(store: store)
                }
            case let .meeting(meeting, standup):
                MeetingView(meeting: meeting, standup: standup)
            }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(), reducer: {
        AppFeature()
            ._printChanges()
    }))
}


#Preview("Quick finishi meeting") {
    var standup = Standup.mock
    standup.duration = .seconds(6)
    
    let detailPath: AppFeature.Path.State = .detail(.init(standup: standup))
    let recordPath: AppFeature.Path.State = .recordMeeting(.init(standup: standup))
    let stackState = StackState([detailPath, recordPath])
    
    let standupListState = StandupsListFeature.State()
    
    let state = AppFeature.State(
        path: StackState([detailPath, recordPath]),
        standupList: standupListState
    )
    
    return AppView(store: Store(initialState: state, reducer: {
        AppFeature()
            ._printChanges()
    }))
}
