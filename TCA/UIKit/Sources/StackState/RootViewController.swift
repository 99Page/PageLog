//
//  RootViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 2/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import UIKit
import SnapKit


@Reducer
struct RootFeature {
    @ObservableState
    struct State {
        var count = 0
        var color: UIColor = .red
        var countState = CountFeature.State()
    }
    
    enum Action {
        case count(CountFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

class RootViewController: UIViewController {
    let store: StoreOf<RootFeature>
    
    private let button = UIButton(type: .custom)
    private let countLabel = UILabel()
    
    init(store: StoreOf<RootFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        updateView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(button)
        view.addSubview(countLabel)
        
        button.addTarget(self, action: #selector(loadOptionalCounterTapped), for: .touchUpInside)
        button.setTitle("Go to set count", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateView() {
        observe { [weak self] in
            guard let self else { return }
            countLabel.text = "\(store.count)"
        }
    }
    
    private func makeConstraints() {
        button.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        countLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(button)
            make.top.equalTo(button.snp.bottom).offset(10)
        }
    }
    
    @objc private func loadOptionalCounterTapped() {
        guard let nav = navigationController as? AppController else {
            fatalError("fail to cast")
        }
        
        nav.push(state: .count(CountFeature.State()))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
