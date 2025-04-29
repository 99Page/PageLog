//
//  Range + overlapping.swift
//  PageCollection
//
//  Created by 노우영 on 12/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Range where Bound: Comparable {
    /// Returns the overlapping range between the current range and another range, if any.
    /// - Parameter other: The range to check for overlap with.
    /// - Returns: The overlapping range as `Range`, or `nil` if there is no overlap.
    ///
    /// # Example
    /// ```
    /// let range1 = 5..<15
    /// let range2 = 10..<20
    /// let overlap = range1.overlapping(with: range2)
    /// print(overlap) // Output: Optional(10..<15)
    ///
    /// let range3 = 20..<25
    /// let noOverlap = range1.overlapping(with: range3)
    /// print(noOverlap) // Output: nil
    /// ```
    func overlapping(with other: Range<Bound>) -> Range<Bound>? {
        let lowerBound = Swift.max(self.lowerBound, other.lowerBound)
        let upperBound = Swift.min(self.upperBound, other.upperBound)
        
        // Check if the calculated bounds form a valid range
        guard lowerBound < upperBound else {
            return nil
        }
        
        return lowerBound..<upperBound
    }
}
