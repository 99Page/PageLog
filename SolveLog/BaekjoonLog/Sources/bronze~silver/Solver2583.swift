//
//  Solver2583.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/11/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver2583 {
    let rowSize: Int
    let colSize: Int
    let rectangleCount: Int
    
    /// 0이면 빈칸
    /// 1이면 직사각형이 있는 칸
    var map: [[Int]]
    var isVisited: [[Bool]]
    
    var sectionSizes: [Int] = []
    
    init() {
        let firstLineInput: [Int] = readArray()
        self.rowSize = firstLineInput[0]
        self.colSize = firstLineInput[1]
        self.rectangleCount = firstLineInput[2]
        
        let colMap = Array(repeating: 0, count: colSize)
        self.map = Array(repeating: colMap, count: rowSize)
        
        let colVisit = Array(repeating: false, count: colSize)
        self.isVisited = Array(repeating: colVisit, count: rowSize)
    }
    
    mutating func solve() {
        readRectangle()
        
        var sectionCount = 0
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                let coordinate = Coordinate(row: row, col: col, distance: 0)
                
                if canEnqueue(coordinate: coordinate) {
                    sectionCount += 1
                    countSectionSize(coordinate: coordinate)
                }
            }
        }
        
        sectionSizes.sort()
        
        print(sectionCount)
        print(sectionSizes.joinedString())
    }
    
    mutating func countSectionSize(coordinate: Coordinate) {
        
        var queue = Queue<Coordinate>()
        queue.enqueue(coordinate)
        
        var sectionSize = 0
        
        isVisited[coordinate.row][coordinate.col] = true
        sectionSize += 1
        
        while !queue.isEmpty {
            let currentCoordinate = queue.dequeue()!
            
            for nextCoordinate in currentCoordinate.findValidNextPositions(rowSize: rowSize, colSize: colSize) {
                if canEnqueue(coordinate: nextCoordinate) {
                    isVisited[nextCoordinate.row][nextCoordinate.col] = true
                    sectionSize += 1
                    queue.enqueue(nextCoordinate)
                }
            }
        }
        
        sectionSizes.append(sectionSize)
    }
    
    func canEnqueue(coordinate: Coordinate) -> Bool {
        !isVisited[coordinate.row][coordinate.col] && map[coordinate.row][coordinate.col] == 0
    }
    
    mutating func readRectangle() {
        (0..<rectangleCount).forEach { _ in
            let rectangleInput: [Int] = readArray()
            let startX = rectangleInput[0]
            let startY = rectangleInput[1]
            let endX = rectangleInput[2]
            let endY = rectangleInput[3]
            
            fillMap(startX: startX, startY: startY, endX: endX, endY: endY)
        }
    }
    
    mutating func fillMap(startX: Int, startY: Int, endX: Int, endY: Int) {
        let startRow = rowSize - endY
        let endRow = rowSize - startY - 1
        
        let startCol = startX
        let endCol = endX - 1
        
        for row in startRow...endRow {
            for col in startCol...endCol {
                map[row][col] = 1
            }
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

    
    struct Coordinate {
        let row: Int
        let col: Int
        let distance: Int
        let arrayIndexBase: ArrayIndexBase
        
        init(row: Int, col: Int, distance: Int, arrayIndexBase: ArrayIndexBase = .zero) {
            self.row = row
            self.col = col
            self.distance = distance
            self.arrayIndexBase = arrayIndexBase
        }
        
        /// 현재 위치에서 이동할 수 있는 모든 유효한 다음 위치를 반환합니다.
        /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
        /// 이동 가능한 방향은 상, 하, 좌, 우 및 대각선입니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 모든 방향으로 이동한 유효한 좌표들을 반환합니다.
        func findValidNextPositionsIncludingDiagonals(rowSize: Int, colSize: Int) -> [Coordinate] {
            let candidates = [
                // 상하좌우
                Coordinate(row: row, col: col - 1, distance: distance + 1), // 왼쪽
                Coordinate(row: row, col: col + 1, distance: distance + 1), // 오른쪽
                Coordinate(row: row - 1, col: col, distance: distance + 1), // 위쪽
                Coordinate(row: row + 1, col: col, distance: distance + 1), // 아래쪽
                
                // 대각선
                Coordinate(row: row - 1, col: col - 1, distance: distance + 1), // 왼쪽 위 대각선
                Coordinate(row: row - 1, col: col + 1, distance: distance + 1), // 오른쪽 위 대각선
                Coordinate(row: row + 1, col: col - 1, distance: distance + 1), // 왼쪽 아래 대각선
                Coordinate(row: row + 1, col: col + 1, distance: distance + 1)  // 오른쪽 아래 대각선
            ]
            
            /// 유효한 좌표만 필터링하여 반환
            return candidates.filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
        }
        
        /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
        /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
        func findValidNextPositions(rowSize: Int, colSize: Int) -> [Coordinate] {
            let candidates = [
                Coordinate(row: row, col: col - 1, distance: distance + 1),
                Coordinate(row: row, col: col + 1, distance: distance + 1),
                Coordinate(row: row - 1, col: col, distance: distance + 1),
                Coordinate(row: row + 1, col: col, distance: distance + 1)
            ]
            
            /// 유효한 좌표만 필터링하여 반환
            return candidates.filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
            
        }
        
        /// 주어진 그리드 크기에서 현재 좌표가 유효한지 확인합니다.
        /// 이 함수는 정사각형 그리드에 대한 유효성을 검사하는 데 사용됩니다.
        ///
        /// - Parameter gridSize: 정사각형 그리드의 크기입니다. 행과 열의 크기가 동일합니다.
        /// - Returns: 현재 좌표가 유효하다면 `true`, 그렇지 않다면 `false`를 반환합니다.
        func isValidCoordinate(gridSize: Int) -> Bool {
            isValidCoordinate(rowSize: gridSize, colSize: gridSize)
        }
        
        /// 주어진 행 크기와 열 크기를 기준으로 현재 좌표가 유효한지 확인합니다.
        /// 이 함수는 직사각형 그리드에 대한 유효성을 검사하는 데 사용됩니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 현재 좌표가 유효하다면 `true`, 그렇지 않다면 `false`를 반환합니다.
        func isValidCoordinate(rowSize: Int, colSize: Int) -> Bool {
            let rowThreshold = rowSize + arrayIndexBase.additionalIndexToSize
            let colThreshold = colSize + arrayIndexBase.additionalIndexToSize
            
            return self.row >= arrayIndexBase.minIndex && self.row < rowThreshold
            && self.col >= arrayIndexBase.minIndex && self.col < colThreshold
        }
        
        enum ArrayIndexBase {
            case zero
            case one
            
            var minIndex: Int {
                switch self {
                case .zero:
                    return 0
                case .one:
                    return 1
                }
            }
            
            var additionalIndexToSize: Int { self.minIndex }
        }
    }
}

private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


