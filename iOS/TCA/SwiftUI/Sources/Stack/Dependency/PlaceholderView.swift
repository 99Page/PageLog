//
//  PlaceholderView.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 3/24/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct PlaceholderFeature {
    
    @ObservableState
    struct State: Equatable, Hashable {
        var title = ""
        var description = ""
    }
    
    enum Action: Equatable, ViewAction {
        case setPost(title: String, description: String)
        case view(View)
        
        enum View: Equatable {
            case buttonTapped
        }
    }
    
    
    @Dependency(\.placeholderClient) var placholderClient
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.buttonTapped):
                let randId = (0..<100).randomElement() ?? 1
                return .run { send in
                    let (title, description) = try await placholderClient.fetchPost(id: randId)
                    await send(.setPost(title: title, description: description))
                }
            case let .setPost(title, description):
                state.title = title
                state.description = description
                return .none
            }
        }
    }
}

@ViewAction(for: PlaceholderFeature.self)
struct PlaceholderView: View {
    
    let store: StoreOf<PlaceholderFeature>
    
    var body: some View {
        List {
            Section("title") {
                Text(store.title)
            }
            
            Section("description") {
                Text(store.description)
            }
            
            Button("fetch post") {
                send(.buttonTapped)
            }
        }
    }
}

#Preview {
    
    let store = Store(initialState: PlaceholderFeature.State()) {
        PlaceholderFeature()
            .dependency(\.placeholderClient, .previewValue)
    }
    
    PlaceholderView(store: store)
}
