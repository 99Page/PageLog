//
//  TooltipModel.swift
//  Tooltip
//
//  Created by 노우영 on 6/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ViewAnchor {
    let source: KeyPath<CGRect, CGFloat>
    let destination: KeyPath<CGRect, CGFloat>
}

@Observable
class TooltipModel {
    private(set) var currentAnchorType: AnchorType?
    private(set) var xAnchor = ViewAnchor(source: \.minX, destination: \.minX)
    private(set) var targetY: KeyPath<CGRect, CGFloat> = \.minY
    
    var anchors: [AnchorType: Anchor<CGRect>] = [:]
    
    var currentAnchor: Anchor<CGRect>? {
        guard let currentAnchorType else { return nil }
        return anchors[currentAnchorType]
    }
    
    func showTooltip(of type: AnchorType, xAnchor: ViewAnchor, targetY: KeyPath<CGRect, CGFloat>) {
        self.currentAnchorType = type
        self.xAnchor = xAnchor
        self.targetY = targetY
    }
}
