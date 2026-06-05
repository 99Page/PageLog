//
//  MyTextField.swift
//  CaseStudies-TCA-UIKit
//
//  Created by 노우영 on 3/18/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SnapKit
import ComposableArchitecture
import UIKit

@Reducer
struct MyTextFeature {
    @ObservableState
    struct State {
        var text = ""
        var underlineColor: UIColor = .black
    }
    
    enum Action: ViewAction {
        case view(View)
        
        enum View: BindableAction {
            case binding(BindingAction<State>)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce<State, Action> { state, action in
            switch action {
            case .view:
                return .none
            }
        }
    }
}

@ViewAction(for: MyTextFeature.self)
class MyTextField: UIView {
    let store: StoreOf<MyTextFeature>
    
    private let textField = UITextField()
    private let underline = UIView()
    
    init(store: StoreOf<MyTextFeature>) {
        self.store = store
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        makeConstraints()
        setupView()
        updateView()
    }
    
    private func setupView() {
        textField.textColor = .gray
        textField.placeholder = "placeholder"
    }
    
    private func makeConstraints() {
        self.addSubview(textField)
        self.addSubview(underline)
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        underline.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(underline)
        }
    }
    
    private func updateView() {
        observe { [weak self] in
            guard let self else { return }
            underline.backgroundColor = store.underlineColor
        }
    }
}
