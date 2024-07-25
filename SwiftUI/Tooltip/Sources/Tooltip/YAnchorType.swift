//
//  YAnchorType.swift
//  Tooltip
//
//  Created by wooyoung on 6/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

enum YAnchorType {
    case minYToMaxY
    case maxYToMinY
    
    var sourceAnchor: KeyPath<CGRect, CGFloat> {
        switch self {
        case .minYToMaxY:
            \.minY
        case .maxYToMinY:
            \.maxY
        }
    }
    
    var destinationAnchor: KeyPath<CGRect, CGFloat> {
        switch self {
        case .minYToMaxY:
            \.maxY
        case .maxYToMinY:
            \.minY
        }
    }
}
