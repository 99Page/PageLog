//
//  Range + overlaps.swift
//  PageCollection
//
//  Created by 노우영 on 12/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

private extension Range where Bound: Comparable {
    /// Checks whether the current range overlaps with another range
    /// - Parameter other: The other range to check for overlap
    /// - Returns: A Boolean value indicating whether the ranges overlap
    func overlaps(with other: Range) -> Bool {
        return self.lowerBound < other.upperBound && self.upperBound > other.lowerBound
    }
}
