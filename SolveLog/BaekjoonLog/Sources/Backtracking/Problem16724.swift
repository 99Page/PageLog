//
//  Problem16742.swift
//  BaekjoonLog
//
//  Created by 노우영 on 11/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

/// 방문 처리 필요.
///
/// 미방문 / 방문 중 / 방문 완료에 대한 상태 구분이 필요한 문제.
/// 하나의 탐색이 완료된 후에도, 그것과 합류하는 또 다른 경로가 있을 수 있는 문제.
struct Problem16724 {
    var rowSize = 0
    var colSize = 0
    
    var map: [[Character]] = []
    var visitState: [[Int]] = []
    
    var safeZoneCount = 0
    
    mutating func solve() {
        readMap()
        countSafeZone()
    }
    
    mutating func countSafeZone() {
        for row in 0..<rowSize {
            for col in 0..<colSize {
                if visitState[row][col] == 0 {
                    let cur = Coordinate(row: row, col: col)
                    visit(cur)
                }
            }
        }
        
        print(safeZoneCount)
    }
    
    mutating func visit(_ cur: Coordinate) {
        let next = nextCoordinate(cur: cur, dir: map[cur.row][cur.col])
        visitState[cur.row][cur.col] = 1
        
        if visitState[next.row][next.col] == 0 {
            visit(next)
        } else if visitState[next.row][next.col] == 1 {
            safeZoneCount += 1
        }
        
        visitState[cur.row][cur.col] = 2
    }
    
    func nextCoordinate(cur: Coordinate, dir: Character) -> Coordinate {
        if dir == "D" {
            return Coordinate(row: cur.row + 1, col: cur.col)
        } else if dir == "U" {
            return Coordinate(row: cur.row - 1, col: cur.col)
        } else if dir == "L" {
            return Coordinate(row: cur.row, col: cur.col - 1)
        } else {
            return Coordinate(row: cur.row, col: cur.col + 1)
        }
    }
    
    mutating func readMap() {
        let mapSize: [Int] = readArray()
        rowSize = mapSize[0]
        colSize = mapSize[1]
        
        (0..<rowSize).forEach { _ in
            let row = [Character](readLine()!)
            map.append(row)
        }
        
        visitState = Array(repeating: Array(repeating: 0, count: colSize), count: rowSize)
    }
    
    struct Coordinate {
        let row: Int
        let col: Int
        
        init(row: Int, col: Int) {
            self.row = row
            self.col = col
        }
   
        func isValidCoordinate(rowSize: Int, colSize: Int) -> Bool {
            let rowThreshold = rowSize
            let colThreshold = colSize
            
            return self.row >= 0 && self.row < rowThreshold
            && self.col >= 0 && self.col < colThreshold
        }
    }

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

