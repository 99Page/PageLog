//
//  Solver2467.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver2467 {
    let n: Int
    var solutions: [Int] = []

    var minValuePointer: (Int, Int) = (0, 0)
    var minValue: Int = .max

    
    init() {
        self.n = readNumberOfSolution()
        self.solutions = readSolutions()
    }
    
    mutating func solve() {
        checkSum(leftPointer: 0, rightPointer: solutions.count - 1)
        print("\(solutions[minValuePointer.0]) \(solutions[minValuePointer.1])")
    }

    /// checkSum 함수는 두 포인터를 사용하여 최소 합을 찾습니다.
    /// - Parameters:
    ///   - leftPointer: 시작 포인터 위치
    ///   - rightPointer: 끝 포인터 위치
    mutating func checkSum(leftPointer: Int, rightPointer: Int) {
        var leftPointer = leftPointer
        var rightPointer = rightPointer
        
        while leftPointer < rightPointer {
            
            let leftValue = solutions[leftPointer]
            let rightValue = solutions[rightPointer]
            
            let currentValue = leftValue + rightValue
            
            if abs(currentValue) < abs(minValue) {
                minValue = abs(currentValue)
                minValuePointer = (leftPointer, rightPointer)
                
                
                if currentValue == 0 {
                    return
                }
            }
            
            if currentValue < 0 {
                leftPointer += 1
            } else {
                rightPointer -= 1
            }
        }
    }
}

/// 입력된 용액의 값을 읽어 solutions 배열에 저장합니다.
private func readSolutions() -> [Int] {
    var solutions: [Int] = []
    
    let solutionsInput = readLine()
    let splitedSolutions = solutionsInput?.split(separator: " ").map { input in
        Int(input)
    }
    
    for solution in splitedSolutions! {
        solutions.append(solution!)
    }
    
    return solutions
}


/// readNumberOfSolution 함수는 용액의 수를 입력받아 정수로 반환합니다.
/// - Returns: 용액의 수
private func readNumberOfSolution() -> Int {
    let result = readLine()
    return Int(result ?? "") ?? 0
}
