//
//  SourceAnchorPreferenceKey.swift
//  Tooltip
//
//  Created by 노우영 on 6/11/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct SourceAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue() ?? value
    }
}
