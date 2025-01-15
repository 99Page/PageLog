//
//  ChatListViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/15/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import SwiftUI
import MessageKit
import ComposableArchitecture
import Combine

@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                return .none
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            }
        }
    }
}

class CounterView: UIView {
    
    let store: StoreOf<CounterFeature>
    
    private let label = UILabel()
    private let incrementButton = UIButton(type: .custom)
    private let decrementButton = UIButton(type: .custom)
    
    init(store: StoreOf<CounterFeature>) {
        self.store = store
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(label)
        addSubview(incrementButton)
        addSubview(decrementButton)
        
        setUpLabel()
        setUpIncrementButton()
        setUpDecrementButton()
    }

    private func setUpLabel() {
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
    }

    private func setUpIncrementButton() {
        incrementButton.setTitle("Increment", for: .normal)
        incrementButton.setTitleColor(.white, for: .normal)
        incrementButton.backgroundColor = .blue
        incrementButton.layer.cornerRadius = 8
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
    }
    
    private func setUpDecrementButton() {
        decrementButton.setTitle("Decrement", for: .normal)
        decrementButton.setTitleColor(.white, for: .normal)
        decrementButton.backgroundColor = .blue
        decrementButton.layer.cornerRadius = 8
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
    }

    private func setUpConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.leading.equalToSuperview()
        }
        
        incrementButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        decrementButton.snp.makeConstraints { make in
            make.top.equalTo(incrementButton.snp.bottom)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalTo(incrementButton)
        }
    }

    
    private func bind() {
        observe { [weak self] in
            guard let self else { return }
            label.text = "\(store.count)"
        }
    }
    
    @objc private func incrementButtonTapped() {
        store.send(.incrementButtonTapped)
    }
    
    @objc private func decrementButtonTapped() {
        store.send(.decrementButtonTapped)
    }
}


#Preview {
    UIViewPreview {
        CounterView(store: Store(initialState: CounterFeature.State(), reducer: {
            CounterFeature()
        }))
    }
    .frame(width: 300, height: 200)
}

