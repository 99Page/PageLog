//
//  PointToGridConverter.swift
//  PageCollection
//
//  Created by 노우영 on 11/11/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct PointToGridConverter {
    static func convert(x: Int, y: Int, rowSize: Int, colSize: Int, arrayIndexBase: ArrayIndexBase = .zero) -> (Int, Int) {
        var row = rowSize - y - 1
        var col = x

        if arrayIndexBase == .one {
            row += 1
            col += 1
        }
        
        return (row, col)
    }
    
    enum ArrayIndexBase {
        case one
        case zero
    }
}
