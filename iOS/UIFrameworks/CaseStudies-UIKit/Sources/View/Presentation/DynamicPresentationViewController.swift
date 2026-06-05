//
//  DynamicPresentationViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 6/29/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DynamicPresentationViewController: UIViewController {
    
    var button = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        button = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(presentView))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func presentView() {
        if #available(iOS 26, *) {
            let vc = UIViewController()

            // LiquidGlass가 적용된 뷰를 반환해서
            // present의 애니메이션 효과를 커스텀할 수 있다. 
            vc.preferredTransition = .zoom { _ in
                self.button
            }
            
            present(vc, animated: true)
        }
    }
}
