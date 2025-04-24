//
//  ToDoCellView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/15/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit

struct ToDoCellState {
    var isDeleteButtonVisible = false
    let toDo: ToDo
}

struct ToDo {
    let description: String
    let number: Int
}

class ToDoCellView: UIView {
    
    private let state: ToDoCellState
    private let label = UILabel()
    private let deleteButton = UIButton()
    
    init(state: ToDoCellState) {
        self.state = state
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints() {
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    /// Configures the default properties of the label.
    private func setUp() {
        self.addSubview(label)
        
        self.backgroundColor = .cyan
        
        setUpLabel()
    }
    
    private func setUpLabel() {
        self.label.text = "\(state.toDo.number). \(state.toDo.description)"
        self.label.numberOfLines = 0
        self.label.textAlignment = .left
        addSwipeGesture()
    }
    
    private func addSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(
            target: self, action: #selector(handleSwipe(_:))
        )
        swipeLeft.direction = .left
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        
    }
}
