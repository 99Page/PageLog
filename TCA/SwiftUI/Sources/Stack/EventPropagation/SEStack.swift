//
//  SEStack.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 7/16/25.
//  Copyright © 2025 Page. All rights reserved.
//


import ComposableArchitecture
import SwiftUI


// Path에서 이벤트를 전달받아 다른 Path의 State를 바꾸거나, Effect를 보내는 방법에 대해서 정리한 타입.
// Reference: https://github.com/pointfreeco/swift-composable-architecture/discussions/3208
@Reducer
struct SEStackFeature {
    
    @Reducer
    enum Path {
        case counter(CounterFeature)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var root = CounterFeature.State()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case root(CounterFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root) {
            CounterFeature()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
                
                // Effect 사용하는 케이스
            case .path(.element(id: _, action: .counter(.delegate(.incrementValue)))):
                guard let index = state.path.firstIndex(where: { $0.is(\.counter)
                }) else { return .none }
                let pathID = state.path.ids[index]
                return .send(.path(.element(id: pathID, action: .counter(.view(.incrementButtonTapped)))))
                
            case .path:
                return .none
                
                // 직접 값을 바꾸는 케이스
            case .root:
                guard let index = state.path.firstIndex(where: { $0.is(\.counter)
                }) else { return .none }
                let pathID = state.path.ids[index]
                state.path[id: pathID, case: \.counter]?.value += 1
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

