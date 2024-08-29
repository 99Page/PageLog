////
////  main.swift
////  2024.APC
////
////  Created by 노우영 on 8/29/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
//let gridSize = Int(readLine()!)!
//let grid: [[Character]] = readGrid(gridSize)
//let mobis: [Character] = ["M", "O", "B", "I", "S"]
//solve()
//
//func solve() {
//    var result: Int = 0
//    
//    
//    for r in (0..<gridSize) {
//        for c in (0..<gridSize) {
//            let character = grid[r][c]
//            
//            if character == "M" {
//                let coordinate = Coordinate(row: r, col: c, distance: 0)
//                let mobisCount = findMobis(coordinate: coordinate)
//                result += mobisCount
//            }
//        }
//    }
//    
//    print(result)
//}
//
//func findMobis(coordinate: Coordinate) -> Int {
//    var count: Int = 0
//    
//    for direction in Direction.allCases {
//        if findMobis(target: 1, direction: direction, coordinate: coordinate) {
//            count += 1
//        }
//    }
//    
//    return count
//}
//
//func findMobis(target: Int, direction: Direction, coordinate: Coordinate) -> Bool {
//    let r = coordinate.row
//    let c = coordinate.col
//    let newR = r + direction.additionalRow
//    let newC = c + direction.additionalCol
//    
//    guard newR >= 0  && newR < gridSize
//            && newC >= 0 && newC < gridSize else {
//        return false
//    }
//    
//    guard target < 4 else {
//        return grid[newR][newC] == mobis[target]
//    }
//    
//    let currentCoordiante = Coordinate(row: newR, col: newC, distance: 0)
//    
//    if grid[newR][newC] == mobis[target] {
//        return findMobis(target: target + 1, direction: direction, coordinate: currentCoordiante)
//    } else {
//        return false
//    }
//    
//}
//
//enum Direction: CaseIterable {
//    case n
//    case ne
//    case e
//    case es
//    case s
//    case sw
//    case w
//    case nw
//    
//    var additionalRow: Int {
//        switch self {
//        case .n:
//            return -1
//        case .ne:
//            return -1
//        case .e:
//            return 0
//        case .es:
//            return 1
//        case .s:
//            return 1
//        case .sw:
//            return 1
//        case .w:
//            return 0
//        case .nw:
//            return -1
//        }
//    }
//    
//    var additionalCol: Int {
//        switch self {
//        case .n:
//            return 0
//        case .ne:
//            return 1
//        case .e:
//            return 1
//        case .es:
//            return 1
//        case .s:
//            return 0
//        case .sw:
//            return -1
//        case .w:
//            return -1
//        case .nw:
//            return -1
//        }
//    }
//}
//
//
//struct Coordinate {
//    let row: Int
//    let col: Int
//    let distance: Int
//    
//    /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
//    /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
//    ///
//    /// - Parameters:
//    ///   - rowSize: 그리드의 행 크기입니다.
//    ///   - colSize: 그리드의 열 크기입니다.
//    /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
//    func findValidNextPositions(rowSize: Int, colSize: Int) -> [Coordinate] {
//        let candidates = [
//            Coordinate(row: row, col: col - 1, distance: distance + 1),
//            Coordinate(row: row, col: col + 1, distance: distance + 1),
//            Coordinate(row: row - 1, col: col, distance: distance + 1),
//            Coordinate(row: row + 1, col: col, distance: distance + 1),
//            
//            /// 대각선
//            Coordinate(row: row + 1, col: col + 1, distance: distance + 1),
//            Coordinate(row: row + 1, col: col - 1, distance: distance + 1),
//            Coordinate(row: row - 1, col: col - 1, distance: distance + 1),
//            Coordinate(row: row - 1, col: col + 1, distance: distance + 1)
//        ]
//        
//        /// 유효한 좌표만 필터링하여 반환
//        return candidates.filter { $0.isValidCoordinate(rowSize: rowSize, colSize: colSize) }
//        
//    }
//    
//    private func isValidCoordinate(rowSize: Int, colSize: Int) -> Bool {
//        self.row >= 0 && self.row < rowSize && self.col >= 0 && self.col < colSize
//    }
//}
//
//
//
//func readGrid(_ k: Int) -> [[Character]] {
//    var result: [[Character]] = []
//        
//    (0..<k).forEach { _ in
//        let line = readLine()!
//        let array = Array(line)
//        result.append(array)
//    }
//    
//    return result
//}
//
//struct Queue<Element> {
//    private var inStack = [Element]()
//    private var outStack = [Element]()
//    
//    var isEmpty: Bool {
//        inStack.isEmpty && outStack.isEmpty
//    }
//    
//    mutating func enqueue(_ newElement: Element) {
//        inStack.append(newElement)
//    }
//    
//    mutating func dequeue() -> Element? {
//        if outStack.isEmpty {
//            outStack = inStack.reversed()
//            inStack.removeAll()
//        }
//        
//        return outStack.popLast()
//    }
//}
