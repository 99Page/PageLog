//
//  Solver14940.swift
//  baekjoon-solve
//
//  Created by 노우영 on 5/20/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver14940 {
    let rowSize: Int
    let colSize: Int
    
    let map: [[Int]]
    
    var distance: [[Int]] = []
    
    private let unvisited = -2
    
    init() {
        let sizeInput: [Int] = readArray()
        rowSize = sizeInput[0]
        colSize = sizeInput[1]
        
        self.map = readGrid(rowSize)
        self.distance = Array(repeating: Array(repeating: unvisited, count: colSize), count: rowSize)
    }
    
    mutating func solve() {
        move(startPoint())
        fillUnvisited()
        printResult()
    }
    
    private func printResult() {
        let result = distance.map {
            $0.map(String.init)
                .joined(separator: " ")
        }
            .joined(separator: "\n")
        
        print(result)
    }
    
    private mutating func fillUnvisited() {
        for row in 0..<rowSize {
            for col in 0..<colSize {
                fillUnvisited(row: row, col: col)
            }
        }
    }
    
    private mutating func fillUnvisited(row: Int, col: Int) {
        if distance[row][col] == unvisited {
            if map[row][col] == 0 {
                distance[row][col] = 0
            } else if map[row][col] == 1 {
                distance[row][col] = -1
            }
        }
    }
    
    private mutating func move(_ start: Coordinate) {
        var queue = Queue<Coordinate>()
        queue.enqueue(start)
        distance[start.row][start.col] = 0
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            for neighbor in current.neighbors(rowSize: rowSize, colSize: colSize) {
                if isVisitable(neighbor) {
                    distance[neighbor.row][neighbor.col] = neighbor.distance
                    queue.enqueue(neighbor)
                }
            }
        }
    }
    
    private func isVisitable(_ coordinate: Coordinate) -> Bool {
        distance[coordinate.row][coordinate.col] == unvisited && map[coordinate.row][coordinate.col] != 0
    }
    
    private func startPoint() -> Coordinate {
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if map[row][col] == 2 {
                    return Coordinate(row: row, col: col, distance: 0)
                }
            }
        }
        
        return Coordinate(row: 0, col: 0, distance: 0)
    }
    
    struct Queue<Element> {
        private var inStack = [Element]()
        private var outStack = [Element]()
        
        /// 큐가 비어있는지 여부를 반환합니다.
        var isEmpty: Bool {
            inStack.isEmpty && outStack.isEmpty
        }

        /// 큐에 있는 요소의 총 개수를 반환합니다.
        var count: Int {
            inStack.count + outStack.count
        }

        /// 큐의 첫 번째 요소를 제거하지 않고 반환합니다.
        var peek: Element? {
            if outStack.isEmpty {
                return inStack.first
            }
            return outStack.last
        }
        
        /// 큐에 요소를 추가합니다.
        /// - Parameter newElement: 큐에 삽입할 요소
        mutating func enqueue(_ newElement: Element) {
            inStack.append(newElement)
        }
        
        /// 큐에서 요소를 제거하고 반환합니다.
        /// - Returns: FIFO 순서로 제거된 요소. 큐가 비어있다면 nil
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
        func neighborsIncludingDiagonals(rowSize: Int, colSize: Int) -> [Coordinate] {
            let directions = [
                (-1, 0), (1, 0), (0, -1), (0, 1),     // 상, 하, 좌, 우
                (-1, -1), (-1, 1), (1, -1), (1, 1)    // 대각선
            ]
            
            return directions
                .map { (dr, dc) in
                    Coordinate(row: row + dr, col: col + dc, distance: distance + 1, arrayIndexBase: arrayIndexBase)
                }
                .filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
        }
        
        /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
        /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
        func neighbors(rowSize: Int, colSize: Int) -> [Coordinate] {
            let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
            
            return directions
                .map { (dr, dc) in
                    Coordinate(row: row + dr, col: col + dc, distance: distance + 1, arrayIndexBase: arrayIndexBase)
                }
                .filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
            
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

private func readGrid<T: LosslessStringConvertible>(_ k: Int) -> [[T]] {
    var result: [[T]] = []
    
    (0..<k).forEach { _ in
        let array: [T] = readArray()
        result.append(array)
    }
    
    return result
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

