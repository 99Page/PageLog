//
//  String + substring.swift
//  PageKit
//
//  Created by 노우영 on 10/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

extension String {
    func substring(range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start..<end])
    }
    
    func substring(range: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
}
