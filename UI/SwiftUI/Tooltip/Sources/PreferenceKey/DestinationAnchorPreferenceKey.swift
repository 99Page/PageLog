//
//  AnchorPreferenceKey.swift
//  Tooltip
//
//  Created by 노우영 on 6/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct DestinationAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: [AnchorType: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [AnchorType: Anchor<CGRect>], nextValue: () -> [AnchorType: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
