//
//  Solver11967.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/11/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

//3 4
//1 1 1 2
//1 1 2 1
//1 2 2 2
//2 1 2 2
//결과: 4

//3 4
//1 1 2 1
//1 1 1 3
//2 1 1 2
//3 3 3 4
//결과: 4

//3 4
//1 1 2 1
//1 1 1 3
//2 1 1 2
//1 3 3 3
//결과: 5


/// 방을 언제 이동할 수 있는가? 에 대한 고민이 필요한 문제
/// 1. 현재 위치에서 불을 켰을 때, 근접한 방에 불이 켜져있으면 갈 수 있고
/// 2. 현재 위치에서 인접한 방의 불이 켜져있는데 방문하지 않았다면 갈 수 있다.
///
/// 결과값은 이동한 방의 개수가아닌 켤 수  있는 불의 수인데, 이걸 놓쳐서 좀 헤맸다.
struct Solver11967 {
    
    /// 0번 인덱스: row
    /// 1번 인덱스: col
    /// 해당 row, col에서 켤 수 있는 방의 좌표들
    var switches: [[[Coordinate]]]
    var isVisited: [[Bool]]
    var isLightOn: [[Bool]]
    
    let rowSize: Int
    let colSize: Int
    
    init() {
        let firstLineInput: [Int] = readArray()
        self.rowSize = firstLineInput[0]
        self.colSize = firstLineInput[1]
        
        let rowSwitch: [[Coordinate]] = Array(repeating: [], count: colSize + 1)
        self.switches = Array(repeating: rowSwitch, count: rowSize + 1)
        
        let visitRow = Array(repeating: false, count: colSize + 1)
        self.isVisited = Array(repeating: visitRow, count: rowSize + 1)
        
        let lightOnRow = Array(repeating: false, count: colSize + 1)
        self.isLightOn = Array(repeating: lightOnRow, count: rowSize + 1)
    }
    
    mutating func solve() {
        readSwitches()
        move()
    }
    
    mutating func move() {
        /// 첫번째 방은 밝혀진 상태
        isLightOn[1][1] = true
        var queue = Queue<Coordinate>()
        
        var result = 1
        
        let firstRoom = Coordinate(row: 1, col: 1, distance: 0, arrayIndexBase: .one)
        queue.enqueue(firstRoom)
        isVisited[firstRoom.row][firstRoom.col] = true
        isLightOn[1][1] = true
        
        while !queue.isEmpty {
            let currentCoordinate = queue.dequeue()!
            
            for nextRoom in switches[currentCoordinate.row][currentCoordinate.col] {
                if !isLightOn[nextRoom.row][nextRoom.col] {
                    isLightOn[nextRoom.row][nextRoom.col] = true
                    result += 1
                }
                
                for nearRoom in nextRoom.findValidNextPositions(rowSize: rowSize, colSize: colSize) {
                    if isVisited[nearRoom.row][nearRoom.col] && !isVisited[nextRoom.row][nextRoom.col] {
                        queue.enqueue(nextRoom)
                        isVisited[nextRoom.row][nextRoom.col] = true
                    }
                }
            }
            
            for nextRoom in currentCoordinate.findValidNextPositions(rowSize: rowSize, colSize: colSize) {
                if !isVisited[nextRoom.row][nextRoom.col] && isLightOn[nextRoom.row][nextRoom.col] {
                    queue.enqueue(nextRoom)
                    isVisited[nextRoom.row][nextRoom.col] = true
                }
            }
        }
        
        print(result)
    }
    
    mutating func readSwitches() {
        (0..<colSize).forEach { _ in
            let switchInput: [Int] = readArray()
            
            let sourceRow = switchInput[0]
            let sourceCol = switchInput[1]
            let targetRow = switchInput[2]
            let targetCol = switchInput[3]
            
            let targetCoordinate = Coordinate(row: targetRow, col: targetCol, distance: 0)
            switches[sourceRow][sourceCol].append(targetCoordinate)
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



private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
