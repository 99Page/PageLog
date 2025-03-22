//
//  PaddedLabel.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // 원하는 패딩 설정

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + textInsets.left + textInsets.right
        let height = size.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: height)
    }
}
