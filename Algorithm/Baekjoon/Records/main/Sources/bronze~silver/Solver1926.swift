//
//  Solver1926.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/2/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1926 {
    let rowSize: Int
    let colSize: Int
    let map: [[Int]]
    
    var isVisited: [[Bool]]
    
    init() {
        let firstLineInput: [Int] = readArray()
        self.rowSize = firstLineInput[0]
        self.colSize = firstLineInput[1]
        self.map = readGrid(k: rowSize)
        
        let visitRow: [Bool] = Array(repeating: false, count: colSize)
        self.isVisited = Array(repeating: visitRow, count: rowSize)
    }
    
    mutating func solve() {
        
        var pictureCount = 0
        var maxPictureSize = 0
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if !isVisited[row][col] && map[row][col] == 1 {
                    let coordinate = Coordinate(row: row, col: col)
                    let size = measurePictureSize(startCoordinate: coordinate)
                    
                    maxPictureSize = max(maxPictureSize, size)
                    pictureCount += 1
                }
            }
        }
        
        print(pictureCount)
        print(maxPictureSize)
    }
    
    mutating func measurePictureSize(startCoordinate coordinate: Coordinate) -> Int {
        var pictureSize = 1
        var pictureQueue = Queue<Coordinate>()
        pictureQueue.enqueue(coordinate)
        isVisited[coordinate.row][coordinate.col] = true
        
        while !pictureQueue.isEmpty {
            let coordinate = pictureQueue.dequeue()!
            
            for nextCoordinate in coordinate.findNextValidCoordinates(rowSize: rowSize, colSize: colSize) {
                let row = nextCoordinate.row
                let col = nextCoordinate.col
                
                if !isVisited[row][col] && map[row][col] == 1 {
                    isVisited[row][col] = true
                    pictureSize += 1
                    pictureQueue.enqueue(nextCoordinate)
                }
            }
        }
        
        return pictureSize
    }
    
    struct Coordinate {
        let row: Int
        let col: Int
        
        func isValidCoordinate(rowSize: Int, colSize: Int) -> Bool {
            self.row >= 0 && self.row < rowSize
            && self.col >= 0 && self.col < colSize
        }
        
        func findNextValidCoordinates(rowSize: Int, colSize: Int) -> [Coordinate] {
            let candiates = [
                Coordinate(row: self.row, col: self.col + 1),
                Coordinate(row: self.row, col: self.col - 1),
                Coordinate(row: self.row + 1, col: self.col),
                Coordinate(row: self.row - 1, col: self.col)
            ]
            
            return candiates.filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
        }
        
    }
    
    struct Queue<Element> {
        private var inStack = [Element]()
        private var outStack = [Element]()
        
        var isEmpty: Bool {
            inStack.isEmpty && outStack.isEmpty
        }
        
        mutating func enqueue(_ newElement: Element) {
            inStack.append(newElement)
        }
        
        mutating func dequeue() -> Element? {
            if outStack.isEmpty {
                outStack = inStack.reversed()
                inStack.removeAll()
            }
            
            return outStack.popLast()
        }
    }

}

private func readGrid<Element: LosslessStringConvertible>(k: Int) -> [[Element]] {
    var result: [[Element]] = []
    
    (0..<k).forEach { _ in
        let row: [Element] = readArray()
        result.append(row)
    }
    
    return result
}

private func readArray<Element: LosslessStringConvertible>() -> [Element] {
    let line = readLine()!
    let element = line.split(separator: " ").map { Element(String($0))! }
    return element
}
