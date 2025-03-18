//
//  ViewInitChildView.swift
//  CaseStudies-TCA
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ViewInitChildFeature {
    
    @ObservableState
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case countTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .countTapped:
                state.count += 1
                return .none
            }
        }
    }
}

struct ViewInitChildView: View {

    let store: StoreOf<ViewInitChildFeature>
    
    var body: some View {
        Button("count: \(store.count)") {
            store.send(.countTapped)
        }
    }
}
