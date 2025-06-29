//
//  NavigationItemViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 6/29/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class NavigationItemViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: nil, action: nil),
            .fixedSpace(0), // fixedSpace를 넣어서 아이템들을 분리할 수 있다
            UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: nil)
        ]
    }
}
