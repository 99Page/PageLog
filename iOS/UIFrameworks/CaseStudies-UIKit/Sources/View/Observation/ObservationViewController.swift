//
//  File.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 6/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

@Observable
class ObservationModel {
    var text = "Hello, world!"
    var radius: CGFloat = 0
}

/// UIKIT의 Observation 기능을 확인하기 위한 UIViewController
///
///   ![UpadateLoopImage](UpdateLoop)
///
/// 뷰의 업데이트 방식입니다.
/// `@Observable` 값이 업데이트 되면 (update traits)
///
/// updateProperties, layoutSubviews가 순서대로 호출됩니다.
/// iOS 26 이전에는 updateProperties는 없었고, UIKIT에서도 상태 기반으로 뷰를 업데이트 하기 위해 새로 추가된 메소드입니다. 
///
/// ## Reference [WWDC25](https://developer.apple.com/videos/play/wwdc2025/243/?time=598)
///
class ObservationViewController: UIViewController {
    
    let model = ObservationModel()
    let simpleLabel = UILabel()
    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraints()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        button.addAction(UIAction(handler: { [weak self] _ in
            if #available(iOS 26, *) {
                
                // .flushUpdates라는 애니메이션 처리 옵션이 추가됐습니다.
                // simpleLabel.layoutIfNeeded()를 호출하지 않아도 됩니다.
                UIView.animate(options: .flushUpdates) {
                    self?.model.text = "Goodbye, world!"
                    self?.model.radius = 30
                }
            }
        }), for: .touchUpInside)
        
        button.setTitle("change text", for: .normal)
        button.setTitleColor(.black, for: .normal)
    }
    
    private func makeConstraints() {
        view.addSubview(simpleLabel)
        view.addSubview(button)
        
        simpleLabel.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.centerX.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalTo(simpleLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if #available(iOS 26.0, *) {
            // iOS 26 버전 사용이 가능할 경우, 새로운 API인 `updateProperties()`를 사용해서
            // 업데이트 할 수 있습니다.
        } else {
            simpleLabel.text = model.text
        }
    }
    
    override func updateProperties() {
        if #available(iOS 26.0, *) {
            super.updateProperties()
            simpleLabel.text = model.text
            simpleLabel.backgroundColor = .blue.withAlphaComponent(0.5)
            simpleLabel.layer.cornerRadius = model.radius
            simpleLabel.layer.masksToBounds = true
        }
    }
}
