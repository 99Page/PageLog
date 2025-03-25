//
//  MockPlaceholderView.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 3/24/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MockPlaceholderFeature: Equatable {
    @ObservableState
    struct State: Equatable, Hashable {
        var placeholder = PlaceholderFeature.State()
    }
    
    enum Action: Equatable {
        case placeholder(PlaceholderFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.placeholder, action: \.placeholder) {
            PlaceholderFeature()
                .dependency(\.placeholderClient, .mockValue)
        }
        
        EmptyReducer()
    }
}

struct MockPlaceholderView: View {
    let store: StoreOf<MockPlaceholderFeature>
    
    var body: some View {
        PlaceholderView(store: store.scope(state: \.placeholder, action: \.placeholder))
    }
}

#Preview {
    let store = Store(initialState: MockPlaceholderFeature.State()) {
        MockPlaceholderFeature()
    }
    
    MockPlaceholderView(store: store)
}
