////
////  main.swift
////  bronze.to.silver.solve
////
////  Created by 노우영 on 9/3/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
//let whieBoard: [[Character]] = [
//    ["W", "B", "W", "B", "W", "B", "W", "B"],
//    ["B", "W", "B", "W", "B", "W", "B", "W"],
//    ["W", "B", "W", "B", "W", "B", "W", "B"],
//    ["B", "W", "B", "W", "B", "W", "B", "W"],
//    ["W", "B", "W", "B", "W", "B", "W", "B"],
//    ["B", "W", "B", "W", "B", "W", "B", "W"],
//    ["W", "B", "W", "B", "W", "B", "W", "B"],
//    ["B", "W", "B", "W", "B", "W", "B", "W"]
//]
//
//let blackBoard: [[Character]] = [
//    ["B", "W", "B", "W", "B", "W", "B", "W"],
//    ["W", "B", "W", "B", "W", "B", "W", "B"],
//    ["B", "W", "B", "W", "B", "W", "B", "W"],
//    ["W", "B", "W", "B", "W", "B", "W", "B"],
//    ["B", "W", "B", "W", "B", "W", "B", "W"],
//    ["W", "B", "W", "B", "W", "B", "W", "B"],
//    ["B", "W", "B", "W", "B", "W", "B", "W"],
//    ["W", "B", "W", "B", "W", "B", "W", "B"],
//]
//
//let gridSize: [Int] = readArray()
//let row = gridSize[0]
//let col = gridSize[1]
//let givenBoard = readBoard()
//let chessBoardRow = 8
//let chessBoardCol = 8
//
//solve()
//
//func solve() {
//    let rowRepeatCount = row - chessBoardRow + 1
//    let colRepeatCount = col - chessBoardCol + 1
//    var result: Int = .max
//    
//    for startRow in (0..<rowRepeatCount) {
//        for startCol in (0..<colRepeatCount) {
//            let currentMinDiff = findMinDiffFrom(startRow: startRow, startCol: startCol)
//            result = min(result, currentMinDiff)
//        }
//    }
//    
//    print(result)
//}
//
//func findMinDiffFrom(startRow: Int, startCol: Int) -> Int {
//    let rowRange = (startRow..<startRow + chessBoardRow)
//    let colRange = (startCol..<startCol + chessBoardCol)
//    
//    let minDiffFromWhiteBoard = countDiffFromWhiteBoard(rowRange: rowRange, colRange: colRange)
//    let minDiffFromBlackBoard = countDiffFromBlackBoard(rowRange: rowRange, colRange: colRange)
//    
//    return min(minDiffFromBlackBoard, minDiffFromWhiteBoard)
//}
//
//func countDiffFromWhiteBoard(rowRange: Range<Int>, colRange: Range<Int>) -> Int {
//    var result: Int = 0
//    var whiteBoardRow = 0
//    
//    for r in rowRange {
//        var whiteBoardCol = 0
//        for c in colRange {
//            if givenBoard[r][c] != whieBoard[whiteBoardRow][whiteBoardCol] {
//                result += 1
//            }
//            
//            whiteBoardCol += 1
//        }
//        
//        whiteBoardRow += 1
//    }
//    
//    return result
//}
//
//func countDiffFromBlackBoard(rowRange: Range<Int>, colRange: Range<Int>) -> Int {
//    var result: Int = 0
//    var blackBoardRow = 0
//    
//    for r in rowRange {
//        var blackBoardCol = 0
//        for c in colRange {
//            if givenBoard[r][c] != blackBoard[blackBoardRow][blackBoardCol] {
//                result += 1
//            }
//            
//            blackBoardCol += 1
//        }
//        
//        blackBoardRow += 1
//    }
//    
//    return result
//}
//
//func readBoard() -> [[Character]] {
//    var result: [[Character]] = []
//    
//    (0..<row).forEach { _ in
//        let line = readLine()!
//        result.append(Array(line))
//    }
//    
//    return result
//}
//
//func readArray<T: LosslessStringConvertible>() -> [T] {
//    let line = readLine()!
//    let splitedLine = line.split(separator: " ")
//    let array = splitedLine.map { T(String($0))! }
//    return array
//}
//
