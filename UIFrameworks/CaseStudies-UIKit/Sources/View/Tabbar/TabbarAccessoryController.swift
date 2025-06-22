//
//  TabbarAccessoryController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 6/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 26.0, *)
class TabbarAccessoryController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buildAccessory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.bottomAccessory = nil
    }
    
    private func buildAccessory() {
        let label = UILabel()
        label.text = "Tabbar Accessory"
        label.textAlignment = .center
        tabBarController?.bottomAccessory = UITabAccessory(contentView: label)
    }
}
