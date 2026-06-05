//
//  DelegateView.swift
//  CaseStudies-TCA
//
//  Created by 노우영 on 2/8/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct DelegateFeature: Equatable {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case onAppear
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

struct DelegateView: View {
    
    @Bindable var store: StoreOf<DelegateFeature>
    
    var body: some View {
        
        
        Text("onAppear Action called!")
            .onAppear {
                store.send(.delegate(.onAppear))
            }
    }
}
