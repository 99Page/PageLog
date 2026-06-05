//
//  TextFieldContainerView.swift
//  CaseStudies-TCA-UIKit
//
//  Created by 노우영 on 3/18/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import SnapKit
import ComposableArchitecture

@Reducer
struct TextFieldContainerFeature {
    @ObservableState
    struct State {
        var textField = MyTextFeature.State()
        var backgroundColor: UIColor = .blue.withAlphaComponent(0.2)
    }
    
    enum Action {
        case textField(MyTextFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.textField, action: \.textField) {
            MyTextFeature()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .textField:
                return .none
            }
        }
    }
}

class TextFieldContainerView: UIViewController {
    
    let store: StoreOf<TextFieldContainerFeature>
    
    private let myTextField: MyTextField
    
    init(store: StoreOf<TextFieldContainerFeature>) {
        self.store = store
        self.myTextField = MyTextField(store: store.scope(state: \.textField, action: \.textField))
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
        
        /// 항상 상위 뷰부터 제약 조건이 걸리고, 하위 뷰의 제약 조건이 생성되어야 합니다.
        /// 편의상 모든 뷰의 구조를 setup-constraint-update 구조로 나뉘었고
        /// 하위 뷰는 이 모든 것이 끝난 후에 설정을 시작해야합니다.
        /// 하위 뷰의 setup-constraint-update 를 configure로 묶고
        /// 적절한 타이밍에 상위 뷰가 호출해주는 구조를 반복합니다.
        myTextField.configure()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    private func makeConstraints() {
        view.addSubview(myTextField)
        
        myTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func updateView() {
        observe { [weak self] in
            guard let self else { return }
            view.backgroundColor = store.backgroundColor
        }
    }
}
