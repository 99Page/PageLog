//
//  AlertViewController.swift
//  CaseStudies-TCA-UIKit
//
//  Created by 노우영 on 6/18/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ComposableArchitecture

@Reducer
struct AlertFeature {
    @ObservableState
    struct State {
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: ViewAction {
        case view(View)
        case alert(PresentationAction<Alert>)
        
        enum View: BindableAction {
            case binding(BindingAction<State>)
            case showButtonTapepd
        }
        
        enum Alert {
            
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce<State, Action> { state, action in
            switch action {
                
            case .view(.showButtonTapepd):
                state.alert = AlertState {
                    TextState("Alert")
                }
                
                return .none
                
            case .view(.binding(_)):
                return .none
                
            case .alert(_):
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

@ViewAction(for: AlertFeature.self)
class MyAlertViewController: UIViewController {
    
    @UIBindable var store: StoreOf<AlertFeature>
    
    init(store: StoreOf<AlertFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        addButton()
        
        present(item: $store.scope(state: \.alert, action: \.alert)) { store in
            UIAlertController(store: store)
        }
    }
    
    private func addButton() {
        let button = UIButton(type: .custom)
        button.setTitle("Show alert", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addAction(UIAction(handler: { [weak self]  _ in
            self?.send(.showButtonTapepd)
        }), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
