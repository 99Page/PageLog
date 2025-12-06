//
//  Solver1030.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1030 {
    
    let time: Int
    let n: Int
    let k: Int
    
    let rowOutputRange: ClosedRange<Int>
    let colOutputRange: ClosedRange<Int>
    
    var map: [[Int]] = []
    
    init() {
        let input: [Int] = readArray()
        
        self.time = input[0]
        self.n = input[1]
        self.k = input[2]
        
        self.rowOutputRange = input[3]...input[4]
        self.colOutputRange = input[5]...input[6]
    }
    
    
    /// The first entry point for the problem solving
    mutating func solve() {
        let rangeLowerBound = 0
        let rangeUpperBound = Int(pow(Double(n), Double(time))) - 1
        let finalFractalRange = rangeLowerBound...rangeUpperBound
        
        self.map = Array(repeating: Array(repeating: 0, count: colOutputRange.count), count: rowOutputRange.count)
        
        processFractal(time: time, rowRange: finalFractalRange, colRange: finalFractalRange, isBlack: false)
        
        print(map.joinedString2D(with: ""))
    }
    
    
    /// Processes the fractal by recursively dividing and filling the matrix.
    /// - Parameters:
    ///   - time: The remaining depth of recursion.
    ///   - rowRange: The range of rows to process.
    ///   - colRange: The range of columns to process.
    ///   - isBlack: A Boolean indicating whether the current part of the fractal is black.
    mutating func processFractal(time: Int, rowRange: ClosedRange<Int>, colRange: ClosedRange<Int>, isBlack: Bool) {
        
        /// Exits  if the given row and col ranges are not within output range
        guard overlapsOutputMatrix(rowRange: rowRange, colRange: colRange) else {
            return
        }
        
        guard !isBlack else {
            fillBlack(rowRange: rowRange, colRange: colRange)
            return
        }
        
        /// Base case: The minimum value of `time` is zero.
        /// When `time` is zero, no further processing will occur.
        guard time > 0 else { return }
        
        let previousFractalLength = rowRange.count / n
        
        /// The current fractal is divided into n^n smaller parts.
        for rowIndex in (1...n) {
            let adding = previousFractalLength * (rowIndex - 1)
            let previousRowLowerBound = rowRange.lowerBound + adding
            let previousRowUpperBound = previousRowLowerBound + previousFractalLength - 1
            
            let previousRowRange = previousRowLowerBound...previousRowUpperBound
            
            for colIndex in (1...n) {
                let adding = previousFractalLength * (colIndex - 1)
                let previousColLowerBound = colRange.lowerBound + adding
                let previousColUpperBound = previousColLowerBound + previousFractalLength - 1
                let previousColRange = previousColLowerBound...previousColUpperBound
                
                if isMiddleFractalIndex(rowIndex: rowIndex, colIndex: colIndex) {
                    /// The middle part of the fractal is filled with black
                    processFractal(time: time - 1, rowRange: previousRowRange, colRange: previousColRange, isBlack: true)
                } else {
                    processFractal(time: time - 1, rowRange: previousRowRange, colRange: previousColRange, isBlack: isBlack)
                }
            }
        }
    }
    
    /// Check whether the given row and column ranges overlap with the matrix output ranges
    /// - Parameters:
    ///   - rowRange: The range of rows to check for overlap
    ///   - colRange: The range of columns to check for overlp
    /// - Returns: A Boolean value indicating whether both row and column ranges overlap the matrix output ranges.
    private func overlapsOutputMatrix(rowRange: ClosedRange<Int>, colRange: ClosedRange<Int>) -> Bool {
        rowOutputRange.overlaps(rowRange) && colOutputRange.overlaps(colRange)
    }
    
    /// Fill the value `1` in the output map for the given row and column ranges.
    /// The ranges will be adjusted to fit within output map.
    /// - Parameters:
    ///   - rowRange: The range of rows to fill in the output map
    ///   - colRange: The range of clumns to fill in the output map
    private mutating func fillBlack(rowRange: ClosedRange<Int>, colRange: ClosedRange<Int>) {
        let rowLowerBound = max(rowRange.lowerBound - rowOutputRange.lowerBound, 0)
        let rowUpperBound = min(rowRange.upperBound - rowOutputRange.lowerBound, rowOutputRange.count - 1)
        let adjustedRowRange = rowLowerBound...rowUpperBound
        
        let colLowerBound = max(colRange.lowerBound - colOutputRange.lowerBound, 0)
        let colUpperBound = min(colRange.upperBound - colOutputRange.lowerBound, colOutputRange.count - 1)
        let adjustedColRange = colLowerBound...colUpperBound
        
        for row in adjustedRowRange {
            for col in adjustedColRange {
                map[row][col] = 1
            }
        }
    }
    
    
    private mutating func isMiddleFractalIndex(rowIndex: Int, colIndex: Int) -> Bool {
        let middleLowerBound = (n - k) / 2 + 1
        let middleUpperBound = middleLowerBound + k - 1
        let middleRange = middleLowerBound...middleUpperBound
        
        return middleRange.contains(rowIndex) && middleRange.contains(colIndex)
        
    }
}

private extension Range where Bound: Comparable {
    /// Checks whether the current range overlaps with another range
    /// - Parameter other: The other range to check for overlap
    /// - Returns: A Boolean value indicating whether the ranges overlap
    func overlaps(with other: Range) -> Bool {
        return self.lowerBound < other.upperBound && self.upperBound > other.lowerBound
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let array = line.split(separator: " ").map { T(String($0))! }
    return array
}

private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}

private extension Array where Element: Collection, Element.Element: LosslessStringConvertible {
    /// 2차원 배열의 각 요소를 문자열로 변환한 후 각 행을 지정된 구분자로 결합하고, 행들은 `\n`으로 구분하여 반환합니다.
    /// - Parameter separator: 각 행 내의 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString2D(with separator: String = " ") -> String {
        self.map { row in
            row.map(String.init).joined(separator: separator)
        }.joined(separator: "\n")
    }
}

