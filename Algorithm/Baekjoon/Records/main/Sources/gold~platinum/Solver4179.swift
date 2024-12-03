//
//  Solver4179.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

//5 5
//#####
//#.J.#
//#.F.#
//#...#
//#...#

//2 2
//JF
//..

//5 5
//#####
//#J.F#
//#...#
//#...#
//##.##

//1 1
//J

//문제를 보고 F가 반드시 한개주어지는 줄 알았는데
//불이 하나도 없을 수도 있고, 여러개 있을수도 있다.
//3 3
//###
//.J#
//###

struct Solver4179 {
    let rowSize: Int
    let colSize: Int
    
    let map: [[Character]]
    
    /// 1 이상인 값은 불이 해당 위치에 도착할 수 있는 최소 거리. 현재 위치를 1로 시작
    /// 0은 가는 길이 없어서 갈 수 없거나 아직 방문하지 않은 곳
    var fireMap: [[Int]]
    
    /// -1은 불이 먼저 도착해서 갈 수 없는 곳
    /// 1 이상인 값은 지훈이가 해당 위치에 도착할 수 있는 최소 거리. 현재 위치를 1로 시작
    /// 0은 가는 길이 없어서 갈 수 없거나 아직 방문하지 않은 곳
    var jihoonMap: [[Int]]
    
    let jihoon: Coordinate
    
    private let initialDistance = 1
    private let firezone = -1
    
    init() {
        let firstLineInput: [Int] = readArray()
        self.rowSize = firstLineInput[0]
        self.colSize = firstLineInput[1]
        
        var map: [[Character]] = []
        
        var jihoonCoordinate = Coordinate(row: 0, col: 0, distance: 0)
        
        for row in 0..<rowSize {
            let rowMap = [Character](readLine()!)
            map.append(rowMap)
            
            if let jihoonIndex = rowMap.firstIndex(of: "J") {
                jihoonCoordinate = Coordinate(row: row, col: jihoonIndex, distance: initialDistance)
            }
        }
        
        self.map = map
        
        self.fireMap = Array(repeating: Array(repeating: 0, count: colSize), count: rowSize)
        self.jihoonMap = fireMap
        
        self.jihoon = jihoonCoordinate
    }
    
    mutating func solve() {
        burn()
        
        let minimumExitDistance = exit()
        
        if minimumExitDistance != nil {
            print(minimumExitDistance!)
        } else {
            print("IMPOSSIBLE")
        }
    }
    
    mutating func exit() -> Int? {
        var exitQueue = Queue<Coordinate>()
        exitQueue.enqueue(jihoon)
        
        jihoonMap[jihoon.row][jihoon.col] = initialDistance
        
        var result: Int?
        
        while !exitQueue.isEmpty {
            let currentCoordinate = exitQueue.dequeue()!
            
            if currentCoordinate.isEdgeOfMatrix(rowSize: rowSize, colSize: colSize) {
                result = currentCoordinate.distance
                break
            }
            
            for nextCoordinate in currentCoordinate.findValidNextPositions(rowSize: rowSize, colSize: colSize) {
                let nextRow = nextCoordinate.row
                let nextCol = nextCoordinate.col
                let nextDistance = nextCoordinate.distance
                
                if isFirstVisitInExit(coordinate: nextCoordinate) {
                    if canVisitFasterThanFire(coordinate: nextCoordinate) {
                        jihoonMap[nextRow][nextCol] = nextDistance
                        exitQueue.enqueue(nextCoordinate)
                    } else {
                        jihoonMap[nextRow][nextCol] = firezone
                    }
                }
            }
        }
        
        return result
    }
    
    private func isFirstVisitInExit(coordinate: Coordinate) -> Bool {
        jihoonMap[coordinate.row][coordinate.col] == 0 && map[coordinate.row][coordinate.col] == "."
    }
    
    private func canVisitFasterThanFire(coordinate: Coordinate) -> Bool {
        coordinate.distance < fireMap[coordinate.row][coordinate.col] || fireMap[coordinate.row][coordinate.col] == 0
    }
    
    mutating func burn() {
        var fireQueue = findFire()
        
        while !fireQueue.isEmpty {
            let curretCoordinate = fireQueue.dequeue()!
            
            for nextCoordinate in curretCoordinate.findValidNextPositions(rowSize: rowSize, colSize: colSize) {
                let nextRow = nextCoordinate.row
                let nextCol = nextCoordinate.col
                
                if isFirstVisitInFire(coordinate: nextCoordinate) {
                    fireMap[nextRow][nextCol] = nextCoordinate.distance
                    fireQueue.enqueue(nextCoordinate)
                }
            }
        }
    }
    
    private func isFirstVisitInFire(coordinate: Coordinate) -> Bool {
        let row = coordinate.row
        let col = coordinate.col
        return fireMap[row][col] == 0 && (map[row][col] == "." || map[row][col] == "J")
    }
    
    private mutating func findFire() -> Queue<Coordinate> {
        var fireQueue = Queue<Coordinate>()
        
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if map[row][col] == "F" {
                    let coordinate = Coordinate(row: row, col: col, distance: initialDistance)
                    fireMap[row][col] = initialDistance
                    fireQueue.enqueue(coordinate)
                }
            }
        }
        
        return fireQueue
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
        
        func isEdgeOfMatrix(rowSize: Int, colSize: Int) -> Bool {
            let minRow = arrayIndexBase.minIndex
            let maxRow = rowSize + arrayIndexBase.additionalIndexToSize - 1
            
            let minCol = arrayIndexBase.minIndex
            let maxCol = colSize + arrayIndexBase.additionalIndexToSize - 1
            
            return row == minRow || row == maxRow || col == minCol || col == maxCol
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
    let array = line.split(separator: " ").map {
        T(String($0))!
    }
    
    return array
}
