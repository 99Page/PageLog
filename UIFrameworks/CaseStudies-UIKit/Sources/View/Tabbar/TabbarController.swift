//
//  File.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 6/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

/// 기본 탭바 컨트롤러
///
/// iOS 26 버전부터 탭바에는 LiquidGlass가 적용됩니다.
/// [참조](https://developer.apple.com/videos/play/wwdc2025/284/)
///
///
class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buildTabbar()
    }
    
    private func setupTabbar() {
        if #available(iOS 26.0, *) {
            // 탭바가 최소화됐을 때 Accessory 뷰가 이동한다.
            self.tabBarMinimizeBehavior = .onScrollDown
        }
    }
    
    private func buildTabbar() {
        
        let viewController = MainViewController()
        viewController.title = "View"
        let firstVC = UINavigationController(rootViewController: viewController)
        firstVC.tabBarItem = UITabBarItem(title: "View", image: UIImage(systemName: "house"), selectedImage: nil)
        
        let secondVC = UINavigationController(rootViewController: MainViewController())
        secondVC.tabBarItem = UITabBarItem(title: "두 번째", image: UIImage(systemName: "star"), selectedImage: nil)
        
        if #available(iOS 26.0, *) {
            let accessoryVC = TabbarAccessoryController()
            accessoryVC.title  = "Accessory"
            accessoryVC.tabBarItem = UITabBarItem(title: "Accessory", image: UIImage(systemName: "plus.app"), selectedImage: nil)
            
            viewControllers = [firstVC, secondVC, accessoryVC]
        } else {
            viewControllers = [firstVC, secondVC]
        }
    }
    
    override func updateProperties() {
        if #available(iOS 26.0, *) {
            super.updateProperties()
            let isInlineAccessory = traitCollection.tabAccessoryEnvironment == .inline
        }
        
    }
}
