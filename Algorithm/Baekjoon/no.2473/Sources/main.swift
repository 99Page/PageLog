//
//  main.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/27/24.
//

import Foundation

/// 합이 가장 작은 것을 어떻게 찾을 것인가??
/// 모든 경우의 수를 볼 수는 없다.
///
/// 투 포인터 + 나머지 한개는 중간지점으로 잡고 여기서 그리디하게 움직이기.
/// 여기에 예외를 찾아볼까.
/// 언제가 예외일까?
/// 중간 지점에서 한쪽 방향으로 움직이는 건 예외 상황없다.
/// 투 포인터에 있는 양쪽 값에 따라 값을 더하든 빼든 한쪽 방향으로만 움직이면 되니까.
/// 투 포인터를 움직였을 때 예외 상황인 경우가 없다면 맞는 솔루션일거 같다.

let solutionCount = Int(readLine()!)!
let solutions = readSolutions()

solve()

func solve() {
    var leftPoint = 0
    var rightPoint = solutionCount - 1
    
    var selectedSolutionsIndex: [Int] = []
    var minSum: Int = .max
    
    while !(rightPoint - leftPoint < 1) {
        let (min, middlePoint) = find(leftPoint: leftPoint, rightPoint: rightPoint)
        
        if min < minSum {
            minSum = min
            selectedSolutionsIndex = [leftPoint, middlePoint, rightPoint]
        }
        
        if solutions[leftPoint] + solutions[rightPoint] > 0 {
            rightPoint -= 1
        } else {
            leftPoint += 1
        }
    }
    
    print("\(solutions[selectedSolutionsIndex[0]]) \(solutions[selectedSolutionsIndex[1]]) \(solutions[selectedSolutionsIndex[2]])")
}

func find(leftPoint: Int, rightPoint: Int) -> (Int, Int) {
    var finalMiddelPoint = -1
    var middlePoint = (leftPoint + rightPoint) / 2
    var sumOfThreeSolution: Int = .max
    
    while middlePoint > leftPoint && middlePoint < rightPoint {
        let newSum = solutions[leftPoint] + solutions[middlePoint] + solutions[rightPoint]
        
        let absoluteNewSum = abs(newSum)
        
        if absoluteNewSum < sumOfThreeSolution {
            finalMiddelPoint = middlePoint
            sumOfThreeSolution = absoluteNewSum
        }
        
        if newSum < 0 {
            middlePoint += 1
        } else {
            middlePoint -= 1
        }
    }
    
    return (sumOfThreeSolution, finalMiddelPoint)
}

func readSolutions() -> [Int] {
    let line = readLine()!
    var solutions = line.split(separator: " ").map { Int($0)! }
    
    solutions.sort()
    return solutions
}
