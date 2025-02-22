//
//  BindingTopView.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 2/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import SnapKit
import ComposableArchitecture
import UIKit
import SwiftUI

@Reducer
struct BindingFeature {
    
    @ObservableState
    struct State {
        var count: Int = 0
        var color: UIColor = .red
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case increaseButtonTapped
        case colorButtonTapepd
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .increaseButtonTapped:
                state.count += 1
                return .none
            case .colorButtonTapepd:
                let candiates: [UIColor] = [.red, .blue, .green, .yellow, .purple]
                state.color = candiates.randomElement() ?? .cyan
                return .none
            default:
                return .none
            }
        }
    }
}

class BindingTopView: UIViewController {
    
    let store: StoreOf<BindingFeature>
    
    let colorView: ColorBindingView
//    let countView: CountBindingView
    
    let increaseButton = UIButton(type: .custom)
    let colorButton = UIButton(type: .custom)
    
    init(store: StoreOf<BindingFeature>) {
        @UIBindable var bindingStore = store
        self.store = store
        self.colorView = ColorBindingView(color: $bindingStore.color)
//        self.countView = CountBindingView(count: $bindingStore.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        updateView()
    }
    
    private func updateView() {
        observe { [weak self] in
            guard let self else { return }
            colorButton.setTitleColor(store.color, for: .normal)
        }
    }
    
    private func setupView() {
        view.addSubview(colorView)
        view.addSubview(colorButton)
        
//        view.addSubview(countView)
        view.addSubview(increaseButton)
        
        view.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        
        increaseButton.setTitle("Increase", for: .normal)
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        
        colorButton.setTitle("Change color", for: .normal)
        colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
    }
    
    private func makeConstraints() {
        colorButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        colorView.snp.makeConstraints { make in
            make.top.equalTo(colorButton.snp.bottom).offset(10)
            make.height.equalTo(50)
            make.left.trailing.equalToSuperview()
        }
    }
    
    @objc private func increaseButtonTapped() {
        store.send(.increaseButtonTapped)
    }
    
    @objc private func colorButtonTapped() {
        store.send(.colorButtonTapepd)
    }
}

#Preview {
    let state = BindingFeature.State()
    
    let store = Store(initialState: state) {
        BindingFeature()
    }
    
    UIViewControllerPreview {
        BindingTopView(store: store)
    }
}
