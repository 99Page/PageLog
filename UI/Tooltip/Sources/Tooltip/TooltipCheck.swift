//
//  TooltipCheck.swift
//  Tooltip
//
//  Created by wooyoung on 6/13/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftData

@Model
class TooltipCheck {
    
    @Attribute(.unique)
    let identifier: String
    var isChecked: Bool
    
    init(identifier: String, isChecked: Bool) {
        self.identifier = identifier
        self.isChecked = isChecked
    }
}
