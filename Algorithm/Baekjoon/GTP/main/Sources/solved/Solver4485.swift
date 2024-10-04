//
//  Solver4485.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver4485 {
    /// 문제를 해결하기 위한 메인 함수
    /// 여러 개의 테스트 케이스를 처리합니다.
    func solve() {
        var caseNum: Int = 1
        
        while true {
            let caveRow = readInt()
            
            if caveRow > 0 {
                solveCase(caveRow: caveRow, caseNum: caseNum)
                caseNum += 1
            } else {
                return
            }
        }
    }

    /// 각 테스트 케이스를 해결하고 결과를 출력하는 함수
    ///
    /// - Parameters:
    ///   - caveRow: 동굴의 행 수. 열과 동일합니다.
    ///   - caseNum: 현재 케이스 번호
    func solveCase(caveRow: Int, caseNum: Int) {
        let cave = readCave(rowCount: caveRow)
        let minLost = searchMinLost(cave: cave)
        
        print("Problem \(caseNum): \(minLost)")
    }

    /// 동굴에서 잃을 수 있는 최소 돈을 계산하는 함수
    ///
    /// - Parameter cave: 동굴의 상태를 나타내는 2차원 배열
    /// - Returns: 잃을 수 있는 최소 돈
    func searchMinLost(cave: [[Int]]) -> Int {
        let rowCount = cave.count
        var memoizationCave: [[Int]] = Array(repeating: Array(repeating: .max, count: rowCount), count: rowCount)
        let dists: [Coordinate] = Coordinate.dists
        
        var queue = Queue<Coordinate>()
        let firstCoordinate = Coordinate(row: 0, col: 0)
        memoizationCave[0][0] = cave[0][0]
        queue.enqueue(firstCoordinate)
        
        while !queue.isEmpty {
            let currentCoordinate = queue.dequeue()!
            let currentCost = memoizationCave[currentCoordinate.row][currentCoordinate.col]
            
            for dist in dists {
                let newRow = currentCoordinate.row + dist.row
                let newCol = currentCoordinate.col + dist.col
                let newCoordinate = Coordinate(row: newRow, col: newCol)
                
                if canEnqueue(cave: cave, memCave: memoizationCave, coordinate: newCoordinate, additionalCost: currentCost) {
                    queue.enqueue(newCoordinate)
                    let newMemCost = currentCost + cave[newRow][newCol]
                    memoizationCave[newRow][newCol] = newMemCost
                }
            }
        }
        
        return memoizationCave[rowCount - 1][rowCount - 1]
    }

    /// 새로운 좌표를 큐에 추가할 수 있는지 확인하는 함수
    ///
    /// - Parameters:
    ///   - cave: 동굴의 상태를 나타내는 2차원 배열
    ///   - memCave: 메모이제이션된 동굴 비용 배열
    ///   - coordinate: 확인할 좌표
    ///   - additionalCost: 현재까지의 비용
    /// - Returns: 큐에 추가할 수 있으면 `true`, 그렇지 않으면 `false`
    func canEnqueue(cave: [[Int]], memCave: [[Int]], coordinate: Coordinate, additionalCost: Int) -> Bool {
        guard isValidCoordinate(coor: coordinate, max: memCave.count) else { return false }
        
        return additionalCost + cave[coordinate.row][coordinate.col] < memCave[coordinate.row][coordinate.col]
    }

    /// 주어진 좌표가 동굴 내에서 유효한지 확인하는 함수
    ///
    /// - Parameters:
    ///   - coordinate: 확인할 좌표
    ///   - max: 동굴의 최대 크기
    /// - Returns: 좌표가 유효하면 `true`, 그렇지 않으면 `false`
    func isValidCoordinate(coor: Coordinate, max: Int) -> Bool {
        return coor.row >= 0 && coor.row < max
        && coor.col >= 0 && coor.col < max
    }

    /// 동굴의 상태를 입력받아 2차원 배열로 반환하는 함수
    ///
    /// - Parameter rowCount: 동굴의 행 수
    /// - Returns: 동굴의 상태를 나타내는 2차원 배열
    func readCave(rowCount: Int) -> [[Int]] {
        var result: [[Int]] = []
        
        (0..<rowCount).forEach { _ in
            let thiefRupeeInRow = readThiefRupeeInRow()
            result.append(thiefRupeeInRow)
        }
        
        return result
    }

    /// 한 줄의 동굴 상태를 입력받아 정수 배열로 반환하는 함수
    ///
    /// - Returns: 동굴 상태를 나타내는 정수 배열
    func readThiefRupeeInRow() -> [Int] {
        let input = readLine()!
        let splitedInput = input.split(separator: " ")
        let thiefRupeeInRow = splitedInput.map { Int($0)! }
        return thiefRupeeInRow
    }



    /// 한 줄의 정수를 입력받아 반환하는 함수
    ///
    /// - Returns: 입력받은 정수
    func readInt() -> Int {
        let input = readLine()!
        return Int(input)!
    }

    struct Coordinate {
        let row: Int
        let col: Int
        
        static let dists: [Coordinate] = [
            right, left, up, down
        ]
        
        private static let right = Coordinate(row: 0, col: 1)
        private static let left = Coordinate(row: 0, col: -1)
        private static let up = Coordinate(row: 1, col: 0)
        private static let down = Coordinate(row: -1, col: 0)
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
