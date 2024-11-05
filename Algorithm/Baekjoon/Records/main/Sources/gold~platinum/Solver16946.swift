//
//  Solver16946.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/5/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver16946 {
    let rowSize: Int
    let colSize: Int
    let map: [[Int]]
    
    var isVisited: [[Bool]]
    var continuousCount: [[Int]]
    var numbers: [[Int]]
    
    var answer: [[Int]]
    
    init() {
        let firstLineInput: [Int] = readArray()
        self.rowSize = firstLineInput[0]
        self.colSize = firstLineInput[1]
        
        var map: [[Int]] = []
        
        (0..<rowSize).forEach { _ in
            let rowInput: [Character] = Array(readLine()!)
            let row: [Int] = rowInput.map { Int(String($0))! }
            map.append(row)
        }
        
        self.map = map
        self.isVisited = Array(repeating: Array(repeating: false, count: colSize), count: rowSize)
        self.continuousCount = Array(repeating: Array(repeating: 0, count: colSize), count: rowSize)
        self.numbers = Array(repeating: Array(repeating: 0, count: colSize), count: rowSize)
        self.answer = Array(repeating: Array(repeating: 0, count: colSize), count: rowSize)
    }
    
    mutating func solve() {
        var number = 1
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                let coordinate = Coordinate(row: row, col: col, distance: 0)
                if canEnqueue(coordinate: coordinate) {
                    let start = Coordinate(row: row, col: col, distance: 0)
                    fillContinuousMap(start: start, number: number)
                    number += 1
                }
            }
        }
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if map[row][col] == 1 {
                    fillAnsertMap(coordinate: Coordinate(row: row, col: col, distance: 0))
                }
            }
        }
        
        print(answer.joinedString2D(with: ""))
    }
    
    mutating func fillAnsertMap(coordinate: Coordinate) {
        var current = 1
        var insertedNumber: Set<Int> = []
        
        for nextCoordinate in coordinate.findValidNextPositions(rowSize: rowSize, colSize: colSize) {
            let number = numbers[nextCoordinate.row][nextCoordinate.col]
            
            if number > 0 && !insertedNumber.contains(number) && map[nextCoordinate.row][nextCoordinate.col] == 0 {
                insertedNumber.insert(number)
                current += continuousCount[nextCoordinate.row][nextCoordinate.col]
            }
        }
        
        answer[coordinate.row][coordinate.col] = (current % 10)
    }
    
    mutating func fillContinuousMap(start: Coordinate, number: Int) {
        var queue = Queue<Coordinate>()
        var insertedStack: [Coordinate] = []
        
        isVisited[start.row][start.col] = true
        queue.enqueue(start)
        insertedStack.append(start)
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            for nextCoordinate in current.findValidNextPositions(rowSize: rowSize, colSize: colSize) {
                if canEnqueue(coordinate: nextCoordinate) {
                    isVisited[nextCoordinate.row][nextCoordinate.col] = true
                    queue.enqueue(nextCoordinate)
                    insertedStack.append(nextCoordinate)
                }
            }
        }
        
        let continuousCount = insertedStack.count
        
        for coordinate in insertedStack {
            self.continuousCount[coordinate.row][coordinate.col] = continuousCount
            self.numbers[coordinate.row][coordinate.col] = number
        }
    }
    
    func canEnqueue(coordinate: Coordinate) -> Bool {
        coordinate.isValidCoordinate(rowSize: rowSize, colSize: colSize)
        && !isVisited[coordinate.row][coordinate.col]
        && map[coordinate.row][coordinate.col] == 0
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

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


