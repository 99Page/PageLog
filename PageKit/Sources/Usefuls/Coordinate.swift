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
