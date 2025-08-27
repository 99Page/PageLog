//
//  SecneDelegate.swift
//  CaseStudies-TCA-UIKit
//
//  Created by 노우영 on 8/26/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = StackController(store: Store(initialState: StackFeature.State(), reducer: {
            StackFeature()
        }))
        self.window = window
        window.makeKeyAndVisible()
    }
}

@Reducer
struct StackFeature {
    @Reducer
    enum Path {
        case list(ImageListFeature)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var caseStudy = CaseStudyFeature.State()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case caseStudy(CaseStudyFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.caseStudy, action: \.caseStudy) {
            CaseStudyFeature()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .caseStudy:
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

class StackController: NavigationStackController {
    private var store: StoreOf<StackFeature>!
    
    convenience init(store: StoreOf<StackFeature>) {
        @UIBindable var store = store
        
        
        self.init(path: $store.scope(state: \.path, action: \.path)) {
            CaseStudyListViewController(store: store.scope(state: \.caseStudy, action: \.caseStudy))
        } destination: { store in
            switch store.case {
            case let .list(store):
                ImageListViewController(store: store)
            }
        }
        
        
        self.store = store
    }
}
