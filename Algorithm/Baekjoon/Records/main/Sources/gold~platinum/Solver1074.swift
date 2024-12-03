//
//  Solver1074.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1074 {
    let n: Int
    let targetMatrixIndex: MatrixIndex
    
    var hasPrintedTargetSequence = false
    
    init() {
        let input: [Int] = readArray()
        
        self.n = input[0]
        self.targetMatrixIndex = MatrixIndex(row: input[1], col: input[2])
    }
    
    /// The initial entry point for problem solving
    mutating func solve() {
        
        
        let lastRow = Int(pow(Double(2), Double(n))) - 1
        let lastIndex = MatrixIndex(row: lastRow, col: lastRow)
        
        let _ = processTargetIndex(exponential: n, lastIndexInMatrix: lastIndex, previousVisitCount: 0)
    }
    
    /// Processes the target matrix index by recursively dividing the matrix and counting visits.
    /// - Parameters:
    ///   - exponential: The exponential value representing the size of the current matrix (2^exponential).
    ///   - lastIndexInMatrix: The bottom-right index of the current matrix.
    ///   - previousVisitCount: The accumulated visit count up to this recursion.
    /// - Returns: The total visit count after processing the current matrix.
    mutating func processTargetIndex(exponential: Int, lastIndexInMatrix: MatrixIndex, previousVisitCount: Int) -> Int {
        /// Exits if the sequence of the target matrix index has already been printed.
        /// The return value in this case is meaningless.
        guard !hasPrintedTargetSequence else { return 0 }
        
        let matrixLength = Int(pow(Double(2), Double(exponential)))
        
        let rowRange = lastIndexInMatrix.row - matrixLength + 1...lastIndexInMatrix.row
        let colRange = lastIndexInMatrix.col - matrixLength + 1...lastIndexInMatrix.col
        
        /// Returns the size of matrix if current matrix range does not contain Target matrix index
        guard containsTargetIndex(rowRange: rowRange, colRange: colRange) else {
            let matrixSize = matrixLength * matrixLength
            return matrixSize
        }
        
        /// An exponential  value of 1 indiciates that the size of matrix is 4.
        guard exponential > 1 else {
            printTarget(matrixIndex: lastIndexInMatrix, count: previousVisitCount)
            return 4
        }
        
        var currentVisitCount = 0
        
        let halfLength = Int(pow(Double(2), Double(exponential - 1)))
        
        let lastIndexOfTopLeft = lastIndexInMatrix.offsetBy(row: -halfLength, col: -halfLength)
        let lastIndexOfTopRight = lastIndexInMatrix.offsetBy(row: -halfLength)
        let lastIndexOfBottomLeft = lastIndexInMatrix.offsetBy(col: -halfLength)
        let lastIndexOfBottomRight = lastIndexInMatrix
        
        currentVisitCount += processTargetIndex(exponential: exponential - 1, lastIndexInMatrix: lastIndexOfTopLeft, previousVisitCount: previousVisitCount + currentVisitCount)
        currentVisitCount += processTargetIndex(exponential: exponential - 1, lastIndexInMatrix: lastIndexOfTopRight, previousVisitCount: previousVisitCount + currentVisitCount)
        currentVisitCount += processTargetIndex(exponential: exponential - 1, lastIndexInMatrix: lastIndexOfBottomLeft, previousVisitCount: previousVisitCount + currentVisitCount)
        currentVisitCount += processTargetIndex(exponential: exponential - 1, lastIndexInMatrix: lastIndexOfBottomRight, previousVisitCount: previousVisitCount + currentVisitCount)

        return currentVisitCount
    }
    
    /// Checks if the target matrix index is within the specified row and column ranges.
    /// - Parameters:
    ///   - rowRange: The range of rows to check.
    ///   - colRange: The range of columns to check.
    /// - Returns: A Boolean value indicating whether the target matrix index is within the given ranges.
    private func containsTargetIndex(rowRange: ClosedRange<Int>, colRange: ClosedRange<Int>) -> Bool {
        return rowRange.contains(targetMatrixIndex.row) && colRange.contains(targetMatrixIndex.col)
    }
    
    /// Updates the state and prints the count if the target matrix index matches any of the adjacent indices.
    /// - Parameters:
    ///   - matrixIndex: The reference index for the matrix.
    ///   - count: The base count to print if a match is found.
    private mutating func printTarget(matrixIndex: MatrixIndex, count: Int) {
        let adjacentIndices = [
            matrixIndex.offsetBy(row: -1, col: -1), // Top-left
            matrixIndex.offsetBy(row: -1),         // Top-right
            matrixIndex.offsetBy(col: -1),         // Bottom-left
            matrixIndex                          // Bottom-right
        ]

        for (offset, index) in adjacentIndices.enumerated() {
            if index == targetMatrixIndex {
                print(count + offset)
                hasPrintedTargetSequence = true
                return
            }
        }
    }
    
    struct MatrixIndex: Equatable {
        let row: Int
        let col: Int
        
        /// Returns a new `MatrixIndex` offset by the specified row and column
        /// - Parameters:
        ///   - row: The number to add the current row
        ///   - col: The number to add the current column
        /// - Returns: A new `MatrixIndex` with updated row and column values
        func offsetBy(row: Int = 0, col: Int = 0) -> MatrixIndex {
            MatrixIndex(row: self.row + row, col: self.col + col)
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let split = line.split(separator: " ")
    return split.map { T(String($0))! }
}
