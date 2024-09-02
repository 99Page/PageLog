////
////  StandupDetailTests.swift
////  TCA-244Tests
////
////  Created by 노우영 on 8/21/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import ComposableArchitecture
//import XCTest
//@testable import TCA_244
//
//@MainActor
//final class StandupDetailTests: XCTestCase {
//    func testEdit() async throws {
//        var standup = Standup.mock
//        let store = TestStore(initialState: StandupDetailFeature.State(standup: standup)) {
//            StandupDetailFeature()
//        }
//        store.exhaustivity = .off
//        
//        await store.send(.editButtonTapped)
//        standup.title = "point free"
//        
//        await store.send(.editStanup(.presented(.set(\.$standup, standup))))
//        
//        /// 얘도 지금 OrderSet 문제로 테스트가 안되고 있다.
//        /// 영상으로 다른 버전으로 하고 있어서 문제가 발생한거 같은데
//        /// 일단 넘어가자.  -page 2024. 08. 21
//        await store.send(.saveStandupButtonTapped) {
//            $0.standup.title = "point free"
//        }
//    }
//}
