//
//  Solver15685.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/2/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver15685 {
    let curveCount: Int
    let curves: [Curve]
    
    let gridSize: Int = 101
    var map: [[Bool]]
    
    init() {
        self.curveCount = Int(readLine()!)!
        self.curves = Self.readCurvies(k: curveCount)
        
        let mapRow = Array(repeating: false, count: gridSize)
        self.map = Array(repeating: mapRow, count: gridSize)
    }
    
    
    /// 문제 풀이를 위한 최초 진입 지점입니다.
    mutating func solve() {
        for curve in curves {
            fillMapBy(curve: curve)
        }
        
        print(countSquare())
    }
    
    /// 네 지점이 전부 방문된 곳의 개수를 셉니다.
    /// - Returns: 네 꼭짓점이 드래곤 커브 일부인 정사각형의 개수
    private func countSquare() -> Int {
        var result = 0
        
        for x in 0..<gridSize - 1 {
            for y in 0..<gridSize - 1 {
                if map[x][y] && map[x+1][y] && map[x][y+1] && map[x+1][y+1] {
                    result += 1
                }
            }
        }
        
        return result
    }
    
    /// 주어진 curve를 이용해 방문 가능한 map에 방문처리합니다.
    /// - Parameters:
    ///   - curve: 방문에 사용한 드래곤 커브
    mutating func fillMapBy(curve: Curve) {
        
        var startPoint = Coordinate(x: curve.startX, y: curve.startY)
        
        /// 하나의 세대에서 사용할 방향입니다.
        var directions: [Direction] = [curve.direction]
        
        /// 전체 세대에서 사용했던 방향입니다.
        var directionLog: [Direction] = []
        
        directionLog.append(contentsOf: directions)
        
        (0...curve.generation).forEach { _ in
            let coordinates = startPoint.nextCoordinates(directions: directions)
            
            for coordinate in coordinates {
                map[coordinate.x][coordinate.y] = true
            }
            
            directions = Direction.nextDirections(directions: directionLog)
            directionLog.append(contentsOf: directions)
            startPoint = coordinates.last!
        }
    }
    
    static func readCurvies(k: Int) -> [Curve] {
        var curves: [Curve] = []
        
        (0..<k).forEach { _ in
            let curveInput: [Int] = readArray()
            let curve = Curve(
                startX: curveInput[0],
                startY: curveInput[1],
                direction: Direction(rawValue: curveInput[2])!,
                generation: curveInput[3]
            )
            curves.append(curve)
        }
        
        return curves
    }
    
    struct Coordinate {
        let x: Int
        let y: Int
        
        /// 현재 지점에서 주어진 방향을 이용해, 다음에 방문해야하는 모든 위치를 구합니다.
        /// - Parameters:
        ///   - directions: 커브가 움직일 순차적인 방향
        /// - Returns: directions을 따라 움직일 때 방문해야하는 모든 위치
        func nextCoordinates(directions: [Direction]) -> [Coordinate] {
            var result: [Coordinate] = [self]
            
            var last = self
            
            for direction in directions {
                let next = last.nextCoordinate(direction: direction)
                result.append(next)
                last = next
                
            }
            
            return result
        }
        
        func nextCoordinate(direction: Direction) -> Coordinate {
            switch direction {
            case .right:
                return Coordinate(x: x + 1, y: y)
            case .up:
                return Coordinate(x: x, y: y - 1)
            case .left:
                return Coordinate(x: x - 1, y: y)
            case .down:
                return Coordinate(x: x, y: y + 1)
            }
        }
    }
    
    struct Curve {
        let startX: Int
        let startY: Int
        let direction: Direction
        let generation: Int
    }
    
    enum Direction: Int {
        case right = 0
        case up = 1
        case left = 2
        case down = 3
        
        /// 다음 세대에서 사용할 위치는 전체 세대에서의 방문 기록을 역으로 뒤집고, 시계방향으로 90도 회전시킨 값입니다.
        /// - Parameters:
        ///   - directions: 전체 세대에서 방문 기록
        /// - Returns: 다음 세대의 좌표가 움직일 순차적인 방향
        static func nextDirections(directions: [Direction]) -> [Direction] {
            let directions = directions.reversed()
            
            return directions.map { $0.rotatedClockwise }
        }
        
        var rotatedClockwise: Direction {
            switch self {
            case .right:
                return .up
            case .up:
                return .left
            case .left:
                return .down
            case .down:
                return .right
            }
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let input = readLine()!
    let result = input.split(separator: " ").map { T(String($0))! }
    return result
}
