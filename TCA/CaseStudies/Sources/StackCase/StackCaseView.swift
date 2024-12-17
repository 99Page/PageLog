//
//  StackCaseView.swift
//  CaseStudies
//
//  Created by 노우영 on 12/17/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StackCaseFeature {
    
    @Reducer
    enum Path: Equatable {
        case alert(AlertCaseFeature)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

struct StackCaseView: View {
    
    @Bindable var store: StoreOf<StackCaseFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                Section("Case Studies") {
                    NavigationLink(state: StackCaseFeature.Path.State.alert(AlertCaseFeature.State())) {
                        Text("Alert")
                    }
                }
            }
        } destination: { store in
            switch store.case {
            case let .alert(store):
                AlertCaseView(store: store)
            }
        }

    }
}

#Preview {
    StackCaseView(store: Store(initialState: StackCaseFeature.State()) {
        StackCaseFeature()
    })
}
