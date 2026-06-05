//
//  CountBindingView.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 2/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture
import UIKit
import SnapKit

class CountBindingView: UIView {
    
    @UIBinding var count: Int
    
    private let label = UILabel(frame: .zero)
    
    init(count: UIBinding<Int>) {
        self._count = count
        super.init(frame: .zero)
        
        setupView()
        updateView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        label.textColor = UIColor.blue
    }
    
    
    private func makeConstraints() {
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func updateView() {
        observe { [weak self] in
            guard let self else { return }
            label.text = "\(count)"
        }
    }
}
