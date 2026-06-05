//
//  XAnchorType.swift
//  Tooltip
//
//  Created by wooyoung on 6/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

enum XAnchorType {
    case minXToMinX
    case midXToMidX
    case maxXToMaxX
    
    var sourceAnchor: KeyPath<CGRect, CGFloat> {
        switch self {
        case .minXToMinX:
            \.minX
        case .midXToMidX:
            \.midX
        case .maxXToMaxX:
            \.maxX
        }
    }
    
    var destinationAnchor: KeyPath<CGRect, CGFloat> {
        switch self {
        case .minXToMinX:
            \.minX
        case .midXToMidX:
            \.midX
        case .maxXToMaxX:
            \.maxX
        }
    }
}
