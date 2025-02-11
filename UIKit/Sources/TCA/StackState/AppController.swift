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
    @Reducer
    enum Path {
        case count(CountFeature)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var rootFeature = RootFeature.State()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case rootFeature(RootFeature.Action)
        case push(Path.State)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.rootFeature, action: \.rootFeature) {
            RootFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .push(pathValue):
                state.path.append(pathValue)
                return .none
            case .rootFeature(.count(.viewDidLoad)):
                return .none
                
            case .path(.element(_, action: .count(.viewDidLoad))):
                state.rootFeature.count += 1
                debugPrint("StackAction Sended!")
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
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
    
    func push(state: AppFeature.Path.State) {
        store.send(.push(state))
    }
}
