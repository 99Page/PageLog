//
//  Coordinate.swift
//  PageCollection
//
//  Created by 노우영 on 8/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Coordinate {
    let row: Int
    let col: Int
    let distance: Int
    
    /// 현재 위치에서 이동할 수 있는 상, 하, 좌, 우의 다음 위치를 반환합니다.
    /// 반환되는 위치들은 0...rowSize-1, 0...colSize-1의 유효 범위 내에 있어야 합니다.
    ///
    /// - Parameters:
    ///   - rowSize: 그리드의 행 크기입니다.
    ///   - colSize: 그리드의 열 크기입니다.
    /// - Returns: 상, 하, 좌, 우로 이동한 유효한 좌표들을 반환합니다.
    func getNextCoordinates(rowSize: Int, colSize: Int) -> [Coordinate] {
        var nextCoordinates: [Coordinate] = []
        
        let left = Coordinate(row: row, col: col - 1, distance: distance + 1)
        let right = Coordinate(row: row, col: col + 1, distance: distance + 1)
        let up = Coordinate(row: row - 1, col: col, distance: distance + 1)
        let down = Coordinate(row: row + 1, col: col, distance: distance + 1)
        
        let candidates = [left, right, up, down]
        
        for candidate in candidates {
            if candidate.isValidCoordinate(rowSize: rowSize, colSize: colSize) {
                nextCoordinates.append(candidate)
            }
        }
        
        return nextCoordinates
    }
    
    private func isValidCoordinate(rowSize: Int, colSize: Int) -> Bool {
        self.row >= 0 && self.row < rowSize && self.col >= 0 && self.col < colSize
    }
}
