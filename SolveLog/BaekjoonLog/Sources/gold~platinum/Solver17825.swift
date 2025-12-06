//
//  Solver17825.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/30/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation


/// 4개의 말
/// 각 주사위 눈금마다 어떤 말을 움직일지 결정. 시간복잡도는 4^10 = 2^20
/// 시간 복잡도 문제는 없어 보이니까, 시뮬레이션 + 경로 지정만 잘해주면 될거같다.
struct Solver17825 {
    
    let diceValues: [Int]
    
    private var result: Int = 0
    private let horseCount = 4
    private let locationCount = 33 // 시작 + 점수판의 개수
    
    let pointsInLocation: [Int] = [
        00, // 시작 지점 1(1)
        02, 04, 06, 08, 10, // 5(6)
        12, 14, 16, 18, 20, // 5(11)
        22, 24, 26, 28, 30, // 5(16)
        32, 34, 36, 38, 40, // 5(21)
        13, 16, 19, 25, // 4(25)
        22, 24, // 2(27)
        28, 27, 26, // 3(30)
        30, 35, // 2(32)
        0 // 도착지점. 1(33)
    ]
    
    let nextPointIndex: [Int] = [
        01,
        02, 03, 04, 05, 06, // 6
        07, 08, 09, 10, 11, // 5
        12, 13, 14, 15, 16, // 5
        17, 18, 19, 20, 32, // 5
        22, 23, 24, 30, // 4
        26, 24, // 2
        28, 29, 24,
        31, 20, // 2
        32 // 1
    ]
    
    let nextPointIndexInFirstMove: [Int] = [
        01,
        02, 03, 04, 05, 21, // 6
        07, 08, 09, 10, 25, // 5
        12, 13, 14, 15, 27, // 5
        17, 18, 19, 20, 32, // 5
        22, 23, 24, 30, // 4
        26, 24, // 2
        28, 29, 24,
        31, 20, // 2
        32 // 1
    ]
    
    init() {
        self.diceValues = readArray()
    }
    
    mutating func solve() {
        let initialPosition = [0, 0, 0, 0]
        move(horseIndex: 0, turn: 1, points: 0, positions: initialPosition)
        
        print(result)
    }
    
    mutating func move(horseIndex: Int, turn: Int, points: Int, positions: [Int]) {
        
        guard turn <= 10 else {
            result = max(result, points)
            return
        }
        
        var newPoints = points
        let moveCount = diceValues[turn - 1]
        var positions = positions
        
        let gainedPoint = move(horseIndex: horseIndex, moveCount: moveCount, positions: &positions)
        
        guard gainedPoint != nil else { return }
        newPoints += gainedPoint!
        
//        print("point: \(newPoints)")
        
        (0..<horseCount).forEach { index in
            move(horseIndex: index, turn: turn + 1, points: newPoints, positions: positions)
        }
    }
    
    /// - Returns: 말이 움직인 위치에 있는 점수. 위치가 중복될 경우 nil
    mutating func move(horseIndex: Int, moveCount: Int, positions: inout [Int]) -> Int? {
        
        printCurrentPosition(positions: positions)
        var currentIndex = positions[horseIndex]
        
        guard currentIndex != 32 else { return nil }
        
        var nextIndex = nextPointIndexInFirstMove[currentIndex]
        var nextIndexPoint = pointsInLocation[nextIndex]
        positions[horseIndex] = nextIndex
        
//        print("말[\(horseIndex)]: \(nextIndexPoint)로 시작점 결정")
        
        (1..<moveCount).forEach { _ in
            currentIndex = positions[horseIndex]
            nextIndex = nextPointIndex[currentIndex]
            nextIndexPoint = pointsInLocation[nextIndex]
            positions[horseIndex] = nextIndex
//            print("말[\(horseIndex)]: \(nextIndexPoint)로 이동")
        }
        
        let lastPosition = positions[horseIndex]
        
        for (index, position) in positions.enumerated() {
            if index != horseIndex && position == lastPosition && position != 32 {
                return nil
            }
        }
        
        return pointsInLocation[lastPosition]
    }
    
    func printCurrentPosition(positions: [Int]) {

        let values: [Int] = positions.map { pointsInLocation[$0] }
//        print(values)
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

