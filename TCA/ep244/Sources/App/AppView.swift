//
//  AppView.swift
//  TCA-244
//
//  Created by 노우영 on 8/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI


@Reducer
struct AppFeature {
    struct State: Equatable {
        var path = StackState<Path.State>()
        var standupList = StandupsListFeature.State()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case standupList(StandupsListFeature.Action)
    }
    
    @Reducer
    struct Path {
        enum State: Equatable {
            case detail(StandupDetailFeature.State)
        }
        
        enum Action {
            case detail(StandupDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                StandupDetailFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.standupList, action: \.standupList) {
            StandupsListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .path(.element(id: id, action: .detail(.saveStandupButtonTapped))):
                guard case let .some(.detail(detailState)) = state.path[id: id]
                else { return .none }
                
                let detailStandupId = detailState.standup.id
                state.standupList.standups[id: detailStandupId] = detailState.standup
                return .none
            case let .path(.popFrom(id: id)):
                /// 내가 고민했던 Sibling끼리의 데이터 업데이트 상황에 대한 TCA의 해결책.
                /// StackView가 모든 상태를 알고 있으니
                /// pop됐을 때 여기서 상태를 업데이트해서 반영할 수 있다.
                /// 이 아이디어를 Vanila Swift에서도 적용해볼만 할 것 같다.
                ///
                /// Sibling 업데이트는 Stack에서 관리하자.
                guard case let .some(.detail(detailState)) = state.path[id: id]
                else { return .none }
                
                let detailStandupId = detailState.standup.id
                state.standupList.standups[id: detailStandupId] = detailState.standup
                return .none
            case .path:
                return .none
            case .standupList(_):
                return .none
            }
        }
        /// optional을 사용했을 때는 ifLet을 사용했다.
        /// stack을 다룰 때는 forEach를 사용한다.
        /// $ 사용 안하니 주의하자.
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            StandupsListView(
                store: store.scope(state: \.standupList, action: \.standupList)
            )
        } destination: { state in
            switch state {
            case .detail:
                CaseLet(\AppFeature.Path.State.detail, action: AppFeature.Path.Action.detail) { store in
                    StandupDetailView(store: store)
                }
            }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(), reducer: {
        AppFeature()
            ._printChanges()
    }))
}
