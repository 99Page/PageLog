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
    
    /// 각 방향으로의 이동을 나타내는 좌표 목록
    static let dists: [Coordinate] = [
        right, left, up, down
    ]
    
    /// 오른쪽으로 이동하는 좌표
    private static let right = Coordinate(row: 0, col: 1)
    /// 왼쪽으로 이동하는 좌표
    private static let left = Coordinate(row: 0, col: -1)
    /// 위로 이동하는 좌표
    private static let up = Coordinate(row: 1, col: 0)
    /// 아래로 이동하는 좌표
    private static let down = Coordinate(row: -1, col: 0)
}
