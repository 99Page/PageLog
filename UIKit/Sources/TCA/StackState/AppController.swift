//
//  AppController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 2/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import UIKit

@Reducer
struct AppFeature {
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var rootFeature = RootFeature.State()
    }
    
    @Reducer
    enum Path {
        case count(CountFeature)
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case rootFeature(RootFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.rootFeature, action: \.rootFeature) {
            RootFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .path(.element(_, .count(.delegate(delegateAction)))):
                switch delegateAction {
                case .increase:
                    state.rootFeature.count += 1
                    return .none
                }
            case .rootFeature(.count(.viewDidLoad)):
//                state.rootFeature.count += 1
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        ._printChanges()
    }
}

class AppController: NavigationStackController {
    private var store: StoreOf<AppFeature>!
    
    
    convenience init(store: StoreOf<AppFeature>) {
        @UIBindable var store = store
        
        
        self.init(path: $store.scope(state: \.path, action: \.path)) {
            RootViewController(store: store.scope(state: \.rootFeature, action: \.rootFeature))
        } destination: { store in
            switch store.case {
            case let .count(store):
                CountViewController(store: store)
            }
        }
        
        
        self.store = store
    }
}
