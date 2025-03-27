//
//  AnchorType.swift
//  Tooltip
//
//  Created by 노우영 on 6/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

enum AnchorType: String {
    case chevron
    case title
    case ellipsis
    case play
    
    var text: String {
        "Here is \(self.rawValue)"
    }
}
