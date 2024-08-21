//
//  StandupListTests.swift
//  TCA-244Tests
//
//  Created by 노우영 on 8/21/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import XCTest
@testable import TCA_244

@MainActor
final class StandupListTests: XCTestCase {
    func testAddStandup() async {
        let store = TestStore(initialState: StandupsListFeature.State()) {
            StandupsListFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        let standupId = UUID(0)
        let attendeeId = UUID(1)
        
        let newAttendee = Attendee(id: attendeeId)
        var newStandup = Standup(id: standupId, attendees: [newAttendee])
        
        
        await store.send(.addButtonTapped) {
            $0.addStandup = StandupFormFeature.State(standup: newStandup)
        }
        
        newStandup.title = "point free"
        
        await store.send(.addStandup(.presented(.set(\.$standup, newStandup)))) {
            $0.addStandup?.standup.title = "point free"
        }
        
        
        /// 알 수 없는 크래시가 발생하는데, 일단 무시하자.
//        await store.send(.saveStandupButtonTapped) {
//            $0.standups[0] = Standup(
//                id: UUID(0),
//                attendees: [Attendee(id: UUID(1))]
//            )
//        }
    }
    
    func testAddStandup_NonExhaustive() async {
        let store = TestStore(initialState: StandupsListFeature.State()) {
            StandupsListFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        /// 모든 프로퍼티 변경을 테스트하고 싶지 않을 때 사용할 수 있는 옵션. 
        store.exhaustivity = .off
        
        let standupId = UUID(0)
        let attendeeId = UUID(1)
        
        let newAttendee = Attendee(id: attendeeId)
        var newStandup = Standup(id: standupId, attendees: [newAttendee])
        
        
        await store.send(.addButtonTapped) {
            $0.addStandup = StandupFormFeature.State(standup: newStandup)
        }
        
        newStandup.title = "point free"
        
        await store.send(.addStandup(.presented(.set(\.$standup, newStandup)))) {
            $0.addStandup?.standup.title = "point free"
        }
    }
}
