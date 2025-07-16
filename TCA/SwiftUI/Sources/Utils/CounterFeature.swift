//
//  CounterFeature.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 7/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var value = 0
    }
    
    enum Action: ViewAction {
        case view(View)
        case delegate(Delegate)
        
        enum View {
            case incrementButtonTapped
        }
        
        @CasePathable
        enum Delegate {
            case incrementValue
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.incrementButtonTapped):
                state.value += 1
                return .send(.delegate(.incrementValue))
            case .delegate:
                return .none
            }
        }
    }
}

@ViewAction(for: CounterFeature.self)
struct CounterView: View {
    
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("\(store.value)")
            
            Button("increment") {
                send(.incrementButtonTapped)
            }
        }
    }
}

#Preview {
    let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
    }
    
    CounterView(store: store)
}
