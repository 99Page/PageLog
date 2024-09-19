//
//  StandupsListView.swift
//  TCA-243Tests
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StandupsListFeature {
    struct State: Equatable {
        @PresentationState var addStandup: StandupFormFeature.State?
        
        /// 동시성 문제로 런타임에 크래시가 발생할 수 있어
        /// pointfree에서 IdentifiedArray 라이브러리를 만들었다.
        /// ID 기반으로 배열을 조회해서 런타임에 안전하다.
        var standups: IdentifiedArrayOf<Standup> = []
        
        init(addStandups: StandupFormFeature.State? = nil) {
            self.addStandup = addStandup
            
            do {
                let data = try Data(contentsOf: .standups)
                self.standups = try JSONDecoder().decode(IdentifiedArrayOf<Standup>.self, from: data)
            } catch {
                self.standups = []
            }
        }
    }
    
    enum Action: Equatable {
        case addButtonTapped
        case addStandup(PresentationAction<StandupFormFeature.Action>)
        case saveStandupButtonTapped
        case cancelStandupButtonTapped
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                let newStandup = Standup(id: self.uuid())
                state.addStandup = StandupFormFeature.State(standup: newStandup)
                return .none
                
            case .addStandup:
                return .none
            case .saveStandupButtonTapped:
                guard let standup = state.addStandup?.standup
                else { return .none }
                state.standups.append(standup)
                state.addStandup = nil
                return .none
            case .cancelStandupButtonTapped:
                state.addStandup = nil
                return .none
            }
        }
        /// 개발하면서 조금 어려운 부분은 화면 전환 후
        /// Child View에서 발생한 변경을 Parent View에 적용하는 것이다.
        /// 예를 들어 List view(parent view) -> Detail view(child view) 이동 후 변경 사항을 적용해야는 상황이 그렇다.
        /// TCA에서는 리듀서를 결합해서 하위 뷰에서 발생한 Action을 상위 뷰에 전파하는 식으로 해결할 수 있다.
        /// 개인적으로는 이게 강력한 부분이라고 생각한다.
        /// 예제로는 sheet이 나왔는데 이걸 navigation 에서도 적용 할 수 있을까?
        .ifLet(\.$addStandup, action: \.addStandup) {
            StandupFormFeature()
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
                    NavigationLink(state: AppFeature.Path.State.detail(StandupDetailFeature.State(standup: standup))) {
                        CardView(scrum: standup)
                            .listRowBackground(standup.theme.mainColor)
                    }
                    
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
            .sheet(
                store: self.store.scope(
                    state: \.$addStandup,
                    action: \.addStandup
                )
            ) { store in
                NavigationStack {
                    /// Sheet으로 나오는 뷰는 독립적으로 봐야할거 같은데
                    /// Action을 공유하는 건 좀 별로인거 같다. 
                    ///
                    /// Parent-child를 할 떄 결국 child view에 필요한 상태 값을
                    /// 부모에서 알고 있고
                    /// 이걸 전달해준다는 개념은 비슷하다.
                    StandupFormView(store: store)
                        .navigationTitle("New standup")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel") {
                                    viewStore.send(.cancelStandupButtonTapped)
                                }
                            }
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Save") {
                                    viewStore.send(.saveStandupButtonTapped)
                                }
                            }
                        }
                }
            }

        }
    }
}

#Preview {
    NavigationStack {
        StandupsListView(
            store: Store(initialState: StandupsListFeature.State(
//                standups: [.mock]
            )) {
                StandupsListFeature()
                    ._printChanges()
            }
        )
    }
}
