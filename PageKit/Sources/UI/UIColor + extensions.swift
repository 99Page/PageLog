//
//  UIColor + extensions.swift
//  PageKit
//
//  Created by 노우영 on 10/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    static var randomPastelColor: UIColor {
        UIColor(
            hue: .random(in: 0...1),       // 색상은 랜덤
            saturation: .random(in: 0.2...0.4), // 낮은 채도
            brightness: .random(in: 0.85...1.0), // 높은 밝기
            alpha: 1.0
        )
    }
}
