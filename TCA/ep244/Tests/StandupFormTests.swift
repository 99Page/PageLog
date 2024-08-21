//
//  StandupFormTests.swift
//  TCA-243Tests
//
//  Created by 노우영 on 8/21/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import XCTest
@testable import TCA_244

@MainActor
final class StandupFormTests: XCTestCase {
    func testAddDeleteAttendee() async {
        let attendee = Attendee(id: UUID())
        let initialStandup: Standup = Standup(id: UUID(), attendees: [attendee])
        
        let store = TestStore(
            initialState: StandupFormFeature.State(standup: initialStandup)) {
                StandupFormFeature()
            } withDependencies: {
                /// UUID를 사용하는 경우, 그 값이 예측 가능하도록
                /// UUID 생성자도 의존성 주입해준다.
                $0.uuid = .incrementing
            }
        
        await store.send(.addAttendeeButtonTapped) {
            $0.focus = .attendee(UUID(0))
            $0.standup.attendees.append(Attendee(id: UUID(0)))
        }
        
        await store.send(.deleteAttendees(atOffsets: [1])) {
            $0.focus = .attendee($0.standup.attendees[0].id)
            $0.standup.attendees.remove(at: 1)
        }
    }
}
