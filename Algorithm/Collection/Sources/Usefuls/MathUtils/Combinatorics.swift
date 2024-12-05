//
//  MathUtils.swift
//  PageCollection
//
//  Created by 노우영 on 12/5/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Combinatorics {
    /// Computes the number of permutations of n objects taken r at a time (P(n, r)).
    /// - Parameters:
    ///   - n: The total number of objects.
    ///   - r: The number of objects to select.
    /// - Returns: The number of permutations or 0 if the input is invalid.
    static func calculatePermutations(n: Int, r: Int) -> Int {
        guard n >= r, r >= 0 else { return 0 }
        return calculateFactorial(of: n) / calculateFactorial(of: n - r)
    }
    
    /// Computes the number of combinations of n objects taken r at a time (C(n, r)).
    /// - Parameters:
    ///   - n: The total number of objects.
    ///   - r: The number of objects to select.
    /// - Returns: The number of combinations or 0 if the input is invalid.
    static func calculateCombinations(n: Int, r: Int) -> Int {
        guard n >= r, r >= 0 else { return 0 }
        return calculateFactorial(of: n) / (calculateFactorial(of: r) * calculateFactorial(of: n - r))
    }
    
    /// Computes the factorial of a given number.
    /// - Parameter n: The number to calculate the factorial of.
    /// - Returns: The factorial of the number.
    static func calculateFactorial(of n: Int) -> Int {
        guard n > 0 else { return 1 }
        return (1...n).reduce(1, *)
    }
}
