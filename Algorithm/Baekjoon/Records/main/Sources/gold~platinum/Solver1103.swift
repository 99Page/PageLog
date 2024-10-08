//
//  Solver1103.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1103 {
    let rowSize: Int
    let colSize: Int
    
    /// i, j를 시작점으로 동전을 던졌을 때 최대로 동전을 던질 수 있는 횟수.
    var mem: [[Int]]
    var map: [[Character]]
    
    init() {
        let input: [Int] = readArray()
        self.rowSize = input[0]
        self.colSize = input[1]
        
        var map: [[Character]] = []
        
        (0..<rowSize).forEach { _ in
            let line = Array(readLine()!)
            map.append(line)
        }
        
        let memRow = Array(repeating: -1, count: colSize)
        self.mem = Array(repeating: memRow, count: rowSize)
        self.map = map
    }
    
    mutating func solve() {
        var isVisited: [[Bool]] = Array(repeating: Array(repeating: false, count: colSize), count: rowSize)
        isVisited[0][0] = true
        
        let initialCoordinate = Coordinate(row: 0, col: 0, distance: 0)
        var result = move(coordinate: initialCoordinate, isVisited: &isVisited)
        
        result = result == .max ? -1 : result
        print(result)
    }
    
    mutating func move(coordinate: Coordinate, isVisited: inout [[Bool]]) -> Int {
        let row = coordinate.row
        let col = coordinate.col
        
        guard mem[row][col] == -1 else { return mem[row][col] }
        
        guard map[row][col] != "H" else {
            mem[row][col] = 0
            return mem[row][col]
        }
        
        let distance = Int(String(map[row][col]))!
        
        for nextCoordinate in coordinate.findValidNextPositions(rowSize: rowSize, colSize: colSize, distance: distance) {
            if isVisited[nextCoordinate.row][nextCoordinate.col] {
                mem[row][col] = .max
            } else {
                isVisited[nextCoordinate.row][nextCoordinate.col] = true
                let maxVisitCount = move(coordinate: nextCoordinate, isVisited: &isVisited)
                let currentMaxCount = maxVisitCount == .max ? .max : maxVisitCount + 1
                isVisited[nextCoordinate.row][nextCoordinate.col] = false
                
                mem[row][col] = max(currentMaxCount, mem[row][col])
            }
        }
        
        /// 현재 위치는 H가 아니기때문에 최소 한번은 동전을 던질 수 있다.
        mem[row][col] = max(mem[row][col], 1)
        
        return mem[row][col]
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
        
        /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
        /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
        ///
        /// - Parameters:
        ///   - rowSize: 그리드의 행 크기입니다.
        ///   - colSize: 그리드의 열 크기입니다.
        /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
        func findValidNextPositions(rowSize: Int, colSize: Int, distance: Int) -> [Coordinate] {
            let candidates = [
                Coordinate(row: row, col: col - distance, distance: distance + 1),
                Coordinate(row: row, col: col + distance, distance: distance + 1),
                Coordinate(row: row - distance, col: col, distance: distance + 1),
                Coordinate(row: row + distance, col: col, distance: distance + 1)
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

