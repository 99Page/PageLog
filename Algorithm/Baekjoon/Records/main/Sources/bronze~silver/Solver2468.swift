//
//  Solver2468.swift
//  baekjoon-solve
//
//  Created by 노우영 on 5/19/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver2468 {
    
    let gridSize: Int
    let areaHeights: [[Int]]
    let maxHeight: Int
    
    init() {
        self.gridSize = Int(readLine()!)!
        
        var initialMap: [[Int]] = []
        var maxHeight: Int = 1
        
        for _ in 0..<gridSize {
            let rowMap: [Int] = readArray()
            initialMap.append(rowMap)
            maxHeight = max(maxHeight, rowMap.max() ?? 1)
        }
        
        self.areaHeights = initialMap
        self.maxHeight = maxHeight
    }
    
    /// 문제 해결의 시작점입니다.
    mutating func solve() {
        var maxSafeAreaCount = 1
        
        for rain in 1...maxHeight {
            let currentSafeAreaCount = countSafeAreaCount(rain: rain)
            maxSafeAreaCount = max(currentSafeAreaCount, maxSafeAreaCount)
        }
        
        print(maxSafeAreaCount)
    }
    
    /// 주어진 비의 양에 의해 생기는 안전 영역의 개수를 셉니다.
    /// - Parameters:
    ///   - rain: 비의 양
    /// - Returns: 안전 영역의 개수
    func countSafeAreaCount(rain: Int) -> Int {
        var isVisited = makeSinkedAreaMap(rain: rain)
        return countSafeAreaCount(with: &isVisited)
    }
    
    /// 방문하지 않은 좌표 중 연속된 좌표들을 하나의 영역으로 취급하며, 존재하는 영역의 개수를 셉니다.
    /// - Parameters: 특정 높이 이하는 방문 처리된 2차원 `Bool` 배열
    /// - Returns: 안전 영역의 개수
    func countSafeAreaCount(with isVisited: inout [[Bool]]) -> Int {
        var safeAreaCount = 0
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if !isVisited[row][col] {
                    safeAreaCount += 1
                    let coordinate = Coordinate(row: row, col: col, distance: 0)
                    checkVisit(in: &isVisited, start: coordinate)
                }
            }
        }
        
        return safeAreaCount
    }
    
    /// 주어진 비의 양 이하는 전부 방문처리한 2차원 `Bool` 배열을 반환합니다.
    /// - Parameters:
    ///   - rain: 비의 양
    /// - Returns: 방문 여부가 표시된 2차원 `Bool` 배열
    func makeSinkedAreaMap(rain: Int) -> [[Bool]] {
        var isVisited = Array(repeating: Array(repeating: false, count: gridSize), count: gridSize)
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if rain >= areaHeights[row][col] {
                    isVisited[row][col] = true
                }
            }
        }
        
        return isVisited
    }
    
    /// 시작점으로부터 연속적인 좌표들을 방문처리합니다.
    /// - Parameters:
    ///   - isVisited: 방문 여부를 확인하는 2차원 `Bool` 배열
    ///   - start: 시작 좌표
    func checkVisit(in isVisitied: inout [[Bool]], start: Coordinate) {
        var queue = Queue<Coordinate>()
        
        queue.enqueue(start)
        isVisitied[start.row][start.col] = true
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            for nextCoordinate in current.findValidNextPositions(rowSize: gridSize, colSize: gridSize) {
                if !isVisitied[nextCoordinate.row][nextCoordinate.col] {
                    isVisitied[nextCoordinate.row][nextCoordinate.col] = true
                    queue.enqueue(nextCoordinate)
                }
            }
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

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
