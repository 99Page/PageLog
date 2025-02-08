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
                
                // UIKit에서는 아래 액션이 발생하지 않는다.
                // SwiftUI에서는 .push라는 액션이 발생하면서, 아래 delegate도 활용이 가능하지만
                // UIKit에서는 어렵다.
                // 일단, 이게 되려면 push를 동작시킬 방법부터 알아야한다.
            case let .path(.element(_, .count(.delegate(delegateAction)))):
                switch delegateAction {
                case .increase:
                    state.rootFeature.count += 1
                    return .none
                }
                
                // 굳이 위 방식처럼 하지 않더라도 이런식으로 우회해서 할 수는 있다.
            case .rootFeature(.count(.viewDidLoad)):
                state.rootFeature.count += 1
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
