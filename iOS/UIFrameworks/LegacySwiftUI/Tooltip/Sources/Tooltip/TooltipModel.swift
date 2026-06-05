//
//  TooltipModel.swift
//  Tooltip
//
//  Created by 노우영 on 6/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

@Observable
class TooltipModel {
    private(set) var currentAnchorType: AnchorType?
    private(set) var xAnchor: XAnchorType = .minXToMinX
    private(set) var yAnchor: YAnchorType = .minYToMaxY
    private(set) var arrowDirection: ArrowDirection = .bottom
    
    let arrowHeight: CGFloat = 6
    var tooltipYOffset: CGFloat {
        switch arrowDirection {
        case .top:
            arrowHeight
        case .bottom:
            -arrowHeight
        }
    }
    
    var anchors: [AnchorType: Anchor<CGRect>] = [:]
    
    var currentAnchor: Anchor<CGRect>? {
        guard let currentAnchorType else { return nil }
        return anchors[currentAnchorType]
    }
    
    func showTooltip(of type: AnchorType, xAnchor: XAnchorType, yAnchor: YAnchorType, arrowDirection: ArrowDirection) {
        self.currentAnchorType = type
        self.xAnchor = xAnchor
        self.yAnchor = yAnchor
        self.arrowDirection = arrowDirection
    }
}
