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
        let standupListState = StandupsListFeature.State(standups: [standup])
        let appState = AppFeature.State(standupList: standupListState)
        
        let store = TestStore(initialState: appState) {
            AppFeature()
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
            $0.path[id: 0, case: \.detail]?.editStandup = standupFormState
        }
        
        var editStandup = standup
        editStandup.title = "Point free"
        
        let editAction = StandupFormFeature.Action.set(\.$standup, editStandup)
        let detailEditAction = StandupDetailFeature.Action.editStanup(.presented(editAction))
        
        
        /// Sibling에서 변경된 사항을 테스트할 수 있다.
        /// 이건.. 좋은거 같다.
        await store.send(.path(.element(id: 0, action: .detail(detailEditAction)))) {
            $0.path[id: 0, case: \.detail]?.editStandup?.standup.title = "Point free"
        }
        
        let saveAction = StandupDetailFeature.Action.saveStandupButtonTapped
        await store.send(.path(.element(id: 0, action: .detail(saveAction)))) {
            $0.path[id: 0, case: \.detail]?.editStandup = nil
            $0.path[id: 0, case: \.detail]?.standup.title = "Point free"
        }
        
        let standupUpdateDelegateAction = StandupDetailFeature.Action.delegate(.standupUpdate(editStandup))
        
        await store.receive(.path(.element(id: 0, action: .detail(standupUpdateDelegateAction)))) {
            $0.standupList.standups[0].title = "Point free"
        }
    }
    
    func testEdit_NonExhaustive() async {
        let standup = Standup.mock
        let standupListState = StandupsListFeature.State(standups: [standup])
        let appState = AppFeature.State(standupList: standupListState)
        
        let store = TestStore(initialState: appState) {
            AppFeature()
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
        let detailEditAction = StandupDetailFeature.Action.editStanup(.presented(editAction))
        
        
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
}
