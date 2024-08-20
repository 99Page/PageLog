//
//  CounterTests.swift
//  TCA#243Tests
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import XCTest
import ComposableArchitecture
@testable import TCA_243

@MainActor
final class CounterTests: XCTestCase {
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
    }
    
    func testTimer() async throws {
        let clock = TestClock()
        
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = true
        }
        
        await clock.advance(by: .seconds(1))
        
        /// Reducer에 의해 발생한 Action은 `receive(_)`로 테스트 합니다.
        await store.receive(.timerTicked) {
            $0.count = 1
        }
        
        await clock.advance(by: .seconds(1))
        
        /// Reducer에 의해 발생한 Action은 `receive(_)`로 테스트 합니다.
        await store.receive(.timerTicked) {
            $0.count = 2
        }
        /// 첫번째 Action을 동작시키면 while문에서 계속 동작합니다.
        /// TCA의 테스트는 발생하는 모든 Action에 대해서 검증을 요구하니
        /// .toggleTimerButtonTapped를 두번 동작시켜서 Action을 계속 반환하지 못하게 해야합니다.
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = false
        }
    }
    
    func testGetFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { count in "\(count) is great number!"}
        }
        
        await store.send(.getFactButtonTapped) {
            $0.isLoadingFact = true
        }
        
        await store.receive(.factResponse("0 is great number!")) {
            $0.fact = "0 is great number!"
            $0.isLoadingFact = false
        }
    }
    
    func testGetFact_Failure() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { _ in
                struct SomeError: Error { }
                throw SomeError()
            }
        }
        
        /// Reducer를 보면 try로 발생한 에러를 별도로 처리해주지 않고 있습니다.
        /// 에러 발생 시의 상태 변화는 달리 테스트할 방법이 없는거 같습니다.
        XCTExpectFailure()
        
        await store.send(.getFactButtonTapped) {
            $0.isLoadingFact = true
        }
    }
}
