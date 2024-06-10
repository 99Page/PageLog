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
    private(set) var targetX: KeyPath<CGRect, CGFloat> = \.minX
    private(set) var targetY: KeyPath<CGRect, CGFloat> = \.minY
    
    var anchors: [AnchorType: Anchor<CGRect>] = [:]
    
    var currentAnchor: Anchor<CGRect>? {
        guard let currentAnchorType else { return nil }
        return anchors[currentAnchorType]
    }
    
    func showTooltip(of type: AnchorType, targetX: KeyPath<CGRect, CGFloat>, targetY: KeyPath<CGRect, CGFloat>) {
        self.currentAnchorType = type
        self.targetX = targetX
        self.targetY = targetY
    }
}
