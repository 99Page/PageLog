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
    struct Path {
        @ObservableState
        enum State: Equatable {
            case placeholder(PlaceholderFeature.State)
            case mock(PlaceholderFeature.State)
        }
        
        enum Action {
            case placeholder(PlaceholderFeature.Action)
            case mock(PlaceholderFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.placeholder, action: \.placeholder) {
                PlaceholderFeature()
            }
            
            Scope(state: \.mock, action: \.mock) {
                PlaceholderFeature()
                    .dependency(\.placeholderClient, .mockValue)
            }
        }
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) { Path() }
    }
}

struct PlaceholderStackCaseView: View {
    
    @Bindable var store: StoreOf<PlaceholderStackFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                NavigationLink(state: PlaceholderStackFeature.Path.State.placeholder(.init())) {
                    Text("product")
                }
                
                NavigationLink(state: PlaceholderStackFeature.Path.State.mock(.init())) {
                    Text("mock")
                }
            }
        } destination: { store in
            switch store.state {
            case .placeholder:
                if let store = store.scope(state: \.placeholder, action: \.placeholder) {
                    PlaceholderView(store: store)
                }
            case .mock:
                if let store = store.scope(state: \.mock, action: \.mock) {
                    PlaceholderView(store: store)
                }
            }
        }
    }
}

