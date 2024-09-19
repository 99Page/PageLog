//
//  AppTests.swift
//  TCA-244Tests
//
//  Created by 노우영 on 8/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import XCTest
@testable import TCA_244

@MainActor
final class AppTests: XCTestCase {
    func testEdit() async {
        let standup = Standup.mock
        let standupListState = StandupsListFeature.State()
        let appState = AppFeature.State(standupList: standupListState)
        
        let store = TestStore(initialState: appState) {
            AppFeature()
        } withDependencies: {
            $0.dataManager = .mock(initialData: try? JSONEncoder().encode(standup))
        }
        
        
        let standupDetailState = StandupDetailFeature.State(standup: standup)
        let appPath: AppFeature.Path.State = .detail(standupDetailState)
        
        await store.send(.path(.push(id: 0, state: appPath))) {
            $0.path[id: 0] = .detail(standupDetailState)
        }
        
        let editButtonTappedAction: AppFeature.Path.Action = .detail(.editButtonTapped)
        let editStackAction: AppFeature.Action = .path(.element(id: 0, action: editButtonTappedAction))
        
        await store.send(editStackAction) {
            let standupFormState = StandupFormFeature.State(standup: standup)
            $0.path[id: 0, case: \.detail]?.desination = .editStandup(standupFormState)
        }
        
        var editStandup = standup
        editStandup.title = "Point free"
        
        let editAction = StandupFormFeature.Action.set(\.$standup, editStandup)
        let detailEditAction = StandupDetailFeature.Action.destination(.presented(.editStandup(editAction)))
        
        
        /// Sibling에서 변경된 사항을 테스트할 수 있다.
        /// 이건.. 좋은거 같다.
        await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.editStandup(.set(\.$standup, editStandup)))))))) { state in
            state.path[id: 0, case: \.detail]?.$desination[case: \.editStandup]?.standup.title = "Point free"
        }
        
        let saveAction = StandupDetailFeature.Action.saveStandupButtonTapped
        await store.send(.path(.element(id: 0, action: .detail(saveAction)))) {
            $0.path[id: 0, case: \.detail]?.desination = nil
            $0.path[id: 0, case: \.detail]?.standup.title = "Point free"
        }
        
        let standupUpdateDelegateAction = StandupDetailFeature.Action.delegate(.standupUpdate(editStandup))
        
        await store.receive(.path(.element(id: 0, action: .detail(standupUpdateDelegateAction)))) {
            $0.standupList.standups[0].title = "Point free"
        }
    }
    
    func testEdit_NonExhaustive() async {
        let standup = Standup.mock
        let standupListState = StandupsListFeature.State()
        let appState = AppFeature.State(standupList: standupListState)
        
        let store = TestStore(initialState: appState) {
            AppFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.dataManager = .mock(initialData: try? JSONEncoder().encode(standup))
        }
        
        store.exhaustivity = .off
        
        
        let standupDetailState = StandupDetailFeature.State(standup: standup)
        let appPath: AppFeature.Path.State = .detail(standupDetailState)
        
        await store.send(.path(.push(id: 0, state: appPath)))
        
        let editButtonTappedAction: AppFeature.Path.Action = .detail(.editButtonTapped)
        let editStackAction: AppFeature.Action = .path(.element(id: 0, action: editButtonTappedAction))
        
        await store.send(editStackAction)
        
        var editStandup = standup
        editStandup.title = "Point free"
        
        let editAction = StandupFormFeature.Action.set(\.$standup, editStandup)
        let detailEditAction = StandupDetailFeature.Action.destination(.presented(.editStandup(.set(\.$standup, editStandup))))
        
        
        /// Sibling에서 변경된 사항을 테스트할 수 있다.
        /// 이건.. 좋은거 같다.
        await store.send(.path(.element(id: 0, action: .detail(detailEditAction))))
        
        let saveAction = StandupDetailFeature.Action.saveStandupButtonTapped
        await store.send(.path(.element(id: 0, action: .detail(saveAction))))
        
        /// Receive한 모든 액션 제거
        await store.skipReceivedActions()
        
        store.assert { state in
            state.standupList.standups[0].title = "Point free"
        }
    }
    
    func testDelete_NonExhaustive() async {
        let standup = Standup.mock
        
        let standupDetailState = StandupDetailFeature.State(standup: standup)
        let stackState: StackState<AppFeature.Path.State> = .init([.detail(standupDetailState)])
        let standupListState = StandupsListFeature.State()
        let appState = AppFeature.State(path: stackState, standupList: standupListState)
        
        let store = TestStore(initialState: appState) {
            AppFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.path(.element(id: 0, action: .detail(.deleteButtonTapped))))
        await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.alert(.confirmDeletion)))))))
        
        await store.skipReceivedActions()
        
        store.assert {
            $0.path = StackState([])
            $0.standupList.standups = []
        }
    }
    
    func testTimerRunOutEndMeeting() async {
        let standup = Standup(
            id: UUID(),
            attendees: [Attendee(id: UUID())],
            duration: .seconds(1),
            meetings: [],
            theme: .bubblegum,
            title: "Point-free"
        )
        
        let standupDetailState: StandupDetailFeature.State = .init(standup: standup)
        let detailPath: AppFeature.Path.State = .detail(standupDetailState)
        
        let recordMeetingState: RecordMeetingFeature.State = .init(standup: standup)
        let recordMeetingPath: AppFeature.Path.State = .recordMeeting(recordMeetingState)
        
        let standupListState: StandupsListFeature.State = .init()
        
        let appState = AppFeature.State(path: StackState([detailPath, recordMeetingPath]), standupList: standupListState)
        
        let store = TestStore(initialState: appState) {
            AppFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.speechClient.requestAuthorization = { .denied }
            $0.date.now = Date(timeIntervalSince1970: 123456789)
            $0.uuid = .incrementing
        }
        
        store.exhaustivity = .off
        
        await store.send(.path(.element(id: 1, action: .recordMeeting(.onTask))))
        
        let saveMeeting: AppFeature.Path.Action = .recordMeeting(.delegate(.saveMeeting(transcript: "")))
        await store.receive(.path(.element(id: 1, action: saveMeeting)))
        await store.receive(.path(.popFrom(id: 1)))
        
        store.assert { state in
            state.path[id: 0, case: \.detail]?.standup.meetings = [
                Meeting(id: UUID(0), date: Date(timeIntervalSince1970: 123456789), transcript: "")
            ]
            
            XCTAssertEqual(state.path.count, 1)
        }
    }
    
    func testTimerRunOutEndMeeting_WithSpeechRecognizer() async {
        let standup = Standup(
            id: UUID(),
            attendees: [Attendee(id: UUID())],
            duration: .seconds(1),
            meetings: [],
            theme: .bubblegum,
            title: "Point-free"
        )
        
        let standupDetailState: StandupDetailFeature.State = .init(standup: standup)
        let detailPath: AppFeature.Path.State = .detail(standupDetailState)
        
        let recordMeetingState: RecordMeetingFeature.State = .init(standup: standup)
        let recordMeetingPath: AppFeature.Path.State = .recordMeeting(recordMeetingState)
        
        let standupListState: StandupsListFeature.State = .init()
        
        let appState = AppFeature.State(path: StackState([detailPath, recordMeetingPath]), standupList: standupListState)
        
        let store = TestStore(initialState: appState) {
            AppFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.speechClient.requestAuthorization = { .denied }
            $0.speechClient.start = {
                AsyncThrowingStream {
                    $0.yield("good meeting!")
                }
            }
            $0.date.now = Date(timeIntervalSince1970: 123456789)
            $0.uuid = .incrementing
            $0.dataManager = .mock(initialData: try? JSONEncoder().encode(standup))
        }
        
        store.exhaustivity = .off
        
        await store.send(.path(.element(id: 1, action: .recordMeeting(.onTask))))
        
        let saveMeeting: AppFeature.Path.Action = .recordMeeting(.delegate(.saveMeeting(transcript: "good meeting!")))
        await store.receive(.path(.element(id: 1, action: saveMeeting)))
        await store.receive(.path(.popFrom(id: 1)))
        
        store.assert { state in
            state.path[id: 0, case: \.detail]?.standup.meetings = [
                Meeting(
                    id: UUID(0),
                    date: Date(timeIntervalSince1970: 123456789),
                    transcript: "good meeting!"
                )
            ]
            
            XCTAssertEqual(state.path.count, 1)
        }
    }
    
    func testEndMeetingEalryDiscard() async {
        let standup = Standup(
            id: UUID(),
            attendees: [Attendee(id: UUID())],
            duration: .seconds(1),
            meetings: [],
            theme: .bubblegum,
            title: "Point-free"
        )
        
        let standupDetailState: StandupDetailFeature.State = .init(standup: standup)
        let detailPath: AppFeature.Path.State = .detail(standupDetailState)
        
        let recordMeetingState: RecordMeetingFeature.State = .init(standup: standup)
        let recordMeetingPath: AppFeature.Path.State = .recordMeeting(recordMeetingState)
        
        let standupListState: StandupsListFeature.State = .init()
        
        let appState = AppFeature.State(path: StackState([detailPath, recordMeetingPath]), standupList: standupListState)
        
        let store = TestStore(initialState: appState) {
            AppFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.speechClient.requestAuthorization = { .denied }
            $0.date.now = .now
            $0.dataManager = .mock(initialData: try? JSONEncoder().encode(standup))
        }
        
        store.exhaustivity = .off
        
        await store.send(.path(.element(id: 1, action: .recordMeeting(.onTask))))
        await store.send(.path(.element(id: 1, action: .recordMeeting(.endMeetingButtonTapped))))
        
        let recordMeetingCofirmDiscardAction: RecordMeetingFeature.Action = .alert(.presented(.confirmDiscard))
        await store.send(.path(.element(id: 1, action: .recordMeeting(recordMeetingCofirmDiscardAction))))
        
        await store.skipReceivedActions()
        
        store.assert { state in
            state.path[id: 0, case: \.detail]?.standup.meetings = []
            XCTAssertEqual(state.path.count, 1)
        }
    }
}
