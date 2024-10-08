//
//  Solver17135.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver17135 {
    let archerCount = 3
    let (rowSize, colSize, attackDistance): (Int, Int, Int)
    let map: [[Int]]
    
    init() {
        let (r, c, a) = readConditions()
        self.rowSize = r
        self.colSize = c
        self.attackDistance = a
        self.map = readMap(rowSize: rowSize)
    }

    func solve() {
        var maxKill = 0
        var archerPositionQueue = Queue<ArcherPositions>()
        let initialArcherPosition: ArcherPositions = .initialPositions
        archerPositionQueue.enqueue(initialArcherPosition)
        
        while !archerPositionQueue.isEmpty {
            let currentArcherPosition = archerPositionQueue.dequeue()!
            
            let killCount = findMaxKill(inCase: currentArcherPosition)
            maxKill = max(maxKill, killCount)
            
            let nextArcherPosition = currentArcherPosition.makeNextPosition(colSize: colSize)
            
            if nextArcherPosition != nil {
                archerPositionQueue.enqueue(nextArcherPosition!)
            }
        }
        
        
        print(maxKill)
    }

    func findMaxKill(inCase archerPositions: ArcherPositions) -> Int {
        var killLog: [[Int]] = map
        var totalKill = 0
        
        (1...rowSize).forEach { turn in
            var nearestEnemies: [Coordinate?] = []
            
            (0..<archerCount).forEach { archerNumber in
                let nearestEnemyFromArcher = findNearestEnenmy(
                    archerPositinons: archerPositions,
                    archerNumber: archerNumber,
                    turn: turn,
                    killLog: killLog
                )
                
                nearestEnemies.append(nearestEnemyFromArcher)
            }
            
            let killCountInTurn = killNearestEnemies(killLog: &killLog, nearestEnemies: nearestEnemies)
            totalKill += killCountInTurn
        }
        
        return totalKill
    }

    func killNearestEnemies(killLog: inout [[Int]], nearestEnemies: [Coordinate?]) -> Int {
        var killCount: Int = 0
        
        for nearestEnemy in nearestEnemies {
            if nearestEnemy != nil && killLog[nearestEnemy!.row][nearestEnemy!.col] == 1 {
                killCount += 1
                killLog[nearestEnemy!.row][nearestEnemy!.col] = 0
            }
        }
        
        return killCount
    }

    func findNearestEnenmy(archerPositinons: ArcherPositions, archerNumber: Int, turn: Int, killLog: [[Int]]) -> Coordinate? {
        var searchQueue = Queue<Coordinate>()
        let isVisitedCol: [Bool] = Array(repeating: false, count: colSize)
        var isVisitedMap: [[Bool]] = Array(repeating: isVisitedCol, count: rowSize)
        var nearestEnemy: Coordinate?
        
        let nearestCoordinate = archerPositinons.findNearestCoordinate(fromArcher: archerNumber,
                                                                       turn: turn,
                                                                       rowSize: rowSize)
        searchQueue.enqueue(nearestCoordinate)
        
        isVisitedMap[nearestCoordinate.row][nearestCoordinate.col] = true
        
        if killLog[nearestCoordinate.row][nearestCoordinate.col] == 1 {
            nearestEnemy = nearestCoordinate
        }
        
        while !(searchQueue.isEmpty || nearestEnemy != nil) {
            let currentCoordinate = searchQueue.dequeue()!
            
            let nextCoordinates = currentCoordinate.nextCoordinates
            
            for nextCoordinate in nextCoordinates {
                if isEnqueuePossible(coordinate: nextCoordinate, isVisited: isVisitedMap) {
                    searchQueue.enqueue(nextCoordinate)
                    isVisitedMap[nextCoordinate.row][nextCoordinate.col] = true
                    
                    if killLog[nextCoordinate.row][nextCoordinate.col] == 1 && nearestEnemy == nil {
                        nearestEnemy = nextCoordinate
                    }
                }
            }
        }
        
        
        return nearestEnemy
    }

    func isEnqueuePossible(coordinate: Coordinate, isVisited: [[Bool]]) -> Bool {
        isValidCoordinate(coordinate: coordinate) && !isVisited[coordinate.row][coordinate.col]
        && coordinate.distanceFromArcher <= attackDistance
    }

    func isValidCoordinate(coordinate: Coordinate) -> Bool {
        coordinate.row >= 0 && coordinate.row < rowSize
        && coordinate.col >= 0 && coordinate.col < colSize
    }


    struct Coordinate {
        let row: Int
        let col: Int
        let distanceFromArcher: Int
        
        var nextCoordinates: [Coordinate] {
            let left = Coordinate(row: row, col: col - 1, distanceFromArcher: distanceFromArcher + 1)
            let up = Coordinate(row: row - 1, col: col, distanceFromArcher: distanceFromArcher + 1)
            let right = Coordinate(row: row, col: col + 1, distanceFromArcher: distanceFromArcher + 1)
            
            return [left, up, right]
        }
    }


    struct ArcherPositions {
        let positions: [Int]
        
        static var initialPositions: ArcherPositions {
            ArcherPositions(positions: [0, 1, 2])
        }
        
        /// - Returns: 궁수들의 새로운 위치를 반환합니다. 구할 수 없는 경우 nil입니다.
        func makeNextPosition(colSize: Int) -> ArcherPositions? {
            if positions[2] < colSize - 1 {
                let newThirdArcherPosition = positions[2] + 1
                return ArcherPositions(positions: [positions[0], positions[1], newThirdArcherPosition])
            } else if positions[1] < colSize - 2 {
                let newSecondArcherPosition = positions[1] + 1
                let newThirdArcherPosition = positions[1] + 2
                return ArcherPositions(positions: [positions[0], newSecondArcherPosition, newThirdArcherPosition])
            } else if positions[0] < colSize - 3 {
                let newFirstArcherPosition = positions[0] + 1
                let newSecondArcherPosition = positions[0] + 2
                let newThirdArcherPosition = positions[0] + 3
                return ArcherPositions(positions: [newFirstArcherPosition, newSecondArcherPosition, newThirdArcherPosition])
            } else {
                return nil
            }
        }
        
        func findNearestCoordinate(fromArcher archer: Int, turn: Int, rowSize: Int) -> Coordinate {
            let archerColumn = self.positions[archer]
            
            return Coordinate(row: rowSize - turn, col: archerColumn, distanceFromArcher: 1)
            
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


/// - Returns: 초기 적이 위치 정보가 담긴 배열. 1인 경우 적이 있고, 0인 경우는 없음.
private func readMap(rowSize: Int) -> [[Int]] {
    var map: [[Int]] = []
    
    (0..<rowSize).forEach { _ in
        let rowInput = readLine()!.split(separator: " ")
        let rowInformation = rowInput.map { Int($0)! }
        map.append(rowInformation)
    }
    
    return map
}

/// - Returns: 행의 크기, 열의 크기, 궁수의 공격 거리
private func readConditions() -> (Int, Int, Int) {
    let input = readLine()!
    let splitedInput = input.split(separator: " ")
    
    let n = Int(splitedInput[0])!
    let m = Int(splitedInput[1])!
    let d = Int(splitedInput[2])!
    
    return (n, m, d)
}
