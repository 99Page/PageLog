//
//  HomeView.swift
//  TCA#243
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 VauDium. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct NumberFactClient {
    var fetch: @Sendable (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static var liveValue: NumberFactClient = .init { number in
        let urlString = "http://www.numbersapi.com/\(number)"
        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let fact = String(decoding: data, as: UTF8.self)
         
        return fact
    }
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isTimerOn = false
        var isLoadingFact = false
    }
    
    /// 내가 느끼는 TCA 단점 중 하나.
    /// View에 불필요한 Action들이 전부 노출된다. 
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case getFactButtonTapped
        case toggleTimerButtonTapped
        case factResponse(String )
        case timerTicked
    }
    
    private enum CancelID {
        case timer
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .getFactButtonTapped:
                state.fact = nil
                state.isLoadingFact = true
                return .run { [count = state.count] send in
                    try await send(.factResponse(self.numberFact.fetch(count)))
                }
            case .timerTicked:
                state.count += 1
                return .none
            case .toggleTimerButtonTapped:
                // TODO: Start a timer
                state.isTimerOn.toggle()
                
                if state.isTimerOn {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTicked)
                        }
                    }
                    /// 동작을 취소시키고 싶은 경우는 아래 modifier를 사용하면 된다.
                    .cancellable(id: CancelID.timer)
                } else {
                    /// .cancel이라는 Effect를 내보냄으로써 해당 id와 동일한 다른 Action이 취소된다.
                    return .cancel(id: CancelID.timer)
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoadingFact = false
                return .none
            }
        }
    }
}

struct ContentView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    Text("\(viewStore.count)")
                    
                    Button("Decrement") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    
                    Button("Increment") {
                        viewStore.send(.incrementButtonTapped)
                    }
                }
                
                Section {
                    HStack {
                        Button("Get fact") {
                            viewStore.send(.getFactButtonTapped)
                        }
                        
                        if viewStore.isLoadingFact {
                            Spacer()
                            ProgressView()
                        }
                    }
                    
                    if let fact = viewStore.fact {
                        Text(fact)
                    }
                }
                
                Section {
                    if viewStore.isTimerOn {
                        Button("Stop timer") {
                            viewStore.send(.toggleTimerButtonTapped)
                        }
                    } else {
                        Button("Start timer") {
                            viewStore.send(.toggleTimerButtonTapped)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    })
}
