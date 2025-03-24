//
//  PlaceholderStackFeature.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 3/24/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct PlaceholderStackFeature {
    
    @Reducer
    enum Path {
        case product(PlaceholderFeature)
        case mockPlaceholder(MockPlaceholderFeature)
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
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

struct PlaceholderStackCaseView: View {
    
    @Bindable var store: StoreOf<PlaceholderStackFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                NavigationLink(state: PlaceholderStackFeature.Path.State.mockPlaceholder(.init())) {
                    Text("product")
                }

                NavigationLink(state: PlaceholderStackFeature.Path.State.mockPlaceholder(.init())) {
                    Text("mock")
                }
            }
        } destination: { store in
            switch store.case {
            case let .mockPlaceholder(store):
                MockPlaceholderView(store: store)
            case let .product(store):
                PlaceholderView(store: store)
            }
        }


    }
}
