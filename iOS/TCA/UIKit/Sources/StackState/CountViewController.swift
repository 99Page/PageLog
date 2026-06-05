//
//  CounterController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 2/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import UIKit


@Reducer
struct CountFeature {
    @ObservableState
    struct State { }
    
    enum Action {
        case viewDidLoad
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewDidLoad:
                return .none
            }
        }
        ._printChanges()
    }
}

class CountViewController: UIViewController {
    let store: StoreOf<CountFeature>
    
    init(store: StoreOf<CountFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        store.send(.viewDidLoad)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
