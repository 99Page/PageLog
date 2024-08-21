//
//  StandupsListView.swift
//  TCA-243Tests
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct StandupsListFeature: Reducer {
    struct State {
        /// 동시성 문제로 런타임에 크래시가 발생할 수 있어
        /// pointfree에서 IdentifiedArray 라이브러리를 만들었다.
        /// ID 기반으로 배열을 조회해서 런타임에 안전하다.
        var standups: IdentifiedArrayOf<Standup> = []
    }
    
    enum Action {
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                let id = UUID()
                let theme = Theme.allCases.randomElement() ?? .bubblegum
                let newStandup = Standup(id: id, theme: theme)
                state.standups.append(newStandup)
                return .none
            }
        }
    }
}

struct StandupsListView: View {
    
    let store: StoreOf<StandupsListFeature>
    
    var body: some View {
        /// State 중 일부 프로퍼티만 관찰하고 싶을 때 keyPath를 사용할 수 있다.
        WithViewStore(self.store, observe: \.standups) { viewStore in
            List {
                ForEach(viewStore.state) { standup in
                    CardView(scrum: standup)
                        .listRowBackground(standup.theme.mainColor)
                }
            }
            .navigationTitle("Daily Standups")
            .toolbar {
                ToolbarItem {
                    Button("Add") { 
                        viewStore.send(.addButtonTapped)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StandupsListView(
            store: Store(initialState: StandupsListFeature.State(standups: [.mock])) {
                StandupsListFeature()
            }
        )
    }
}
