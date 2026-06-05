//
//  ToggleViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 2/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import UIKit
import SnapKit
import SwiftUI


@Reducer
struct ToggleListFeature {
    @ObservableState
    struct State {
        /// 토글 상태 배열
        ///
        /// - Note: 배열에 사용할 타입들은 Equtable이 필수입니다.
        /// Equtable을 채택해야 $store.toggles[0] subscript 사용이 가능합니다.
        var toggles = IdentifiedArrayOf<ToggleState>()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
            case .addButtonTapped:
                state.toggles.append(ToggleState())
                return .none
            }
        }
    }
}


class ToggleListViewController: UIViewController {
    
    @UIBindable var store = Store(initialState: ToggleListFeature.State()) {
        ToggleListFeature()
    }
    
    private let tableView = UITableView()
    private let addToggleButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        updateView()
    }
    
    private func updateView() {
        observe { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.register(ToggleCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.backgroundColor = .blue.withAlphaComponent(0.1)
        
        addToggleButton.setTitle("Add toggle", for: .normal)
        addToggleButton.setTitleColor(.black, for: .normal)
        addToggleButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        store.send(.addButtonTapped)
    }
    
    private func makeConstraints() {
        view.addSubview(tableView)
        view.addSubview(addToggleButton)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(addToggleButton.snp.top).offset(-10)
        }
        
        addToggleButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension ToggleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.toggles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! ToggleCell
        cell.configure($store.toggles[indexPath.row])
        return cell
    }
}

#Preview {
    UIViewControllerPreview {
        ToggleListViewController()
    }
}
