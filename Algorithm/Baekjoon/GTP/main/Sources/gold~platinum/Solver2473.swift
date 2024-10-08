//
//  Solver2473.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver2473 {
    /// 합이 가장 작은 것을 어떻게 찾을 것인가??
    /// 모든 경우의 수를 볼 수는 없다.

    let solutionCount: Int
    let solutions: [Int]
    
    init() {
        self.solutionCount = Int(readLine()!)!
        self.solutions = readSolutions()
    }

    func solve() {
        
        var finalSolutionSum = SolutionSum(absSum: .max, selectedSolutionIndexes: [0, 0, 0])
        
        for fixedSolutionPoint in (0..<solutionCount) {
            let solutionSum = findMinAbsoluteSum(with: fixedSolutionPoint)
            
            if solutionSum.absSum < finalSolutionSum.absSum {
                finalSolutionSum = solutionSum
            }
            
            if finalSolutionSum.absSum == 0 {
                break
            }
        }
        
        let sortedIndex = finalSolutionSum.selectedSolutionIndexes.sorted()
        let firstSolution = solutions[sortedIndex[0]]
        let secondSolution = solutions[sortedIndex[1]]
        let thirdSolution = solutions[sortedIndex[2]]
        
        print(firstSolution, secondSolution, thirdSolution)
    }

    func findMinAbsoluteSum(with fixedSolutionPoint: Int) -> SolutionSum {
        var leftPoint = fixedSolutionPoint + 1
        var rightPoint = solutionCount - 1
        
        let selectedSolutionIndexes: [Int] = [fixedSolutionPoint, leftPoint, rightPoint]
        var solutionSum = SolutionSum(absSum: .max, selectedSolutionIndexes: selectedSolutionIndexes)
        
        avoidFixedSolutionPoint(
            fixedSolutionPoint: fixedSolutionPoint,
            leftPoint: &leftPoint,
            rightPoint: &rightPoint
        )
        
        let fixedSolution = solutions[fixedSolutionPoint]
        
        while leftPoint < rightPoint {
            let twoSolutionsSum = solutions[leftPoint] + solutions[rightPoint]
            
            let threeSolutionsSum = twoSolutionsSum + fixedSolution
            
            if abs(threeSolutionsSum) < solutionSum.absSum {
                let newSelectedIndexes = [fixedSolutionPoint, leftPoint, rightPoint]
                solutionSum = SolutionSum(absSum: abs(threeSolutionsSum), selectedSolutionIndexes: newSelectedIndexes)
            }
            
            if solutionSum.absSum == 0 {
                break
            }
            
            if threeSolutionsSum > 0 {
                rightPoint -= 1
            } else {
                leftPoint += 1
            }
            
            avoidFixedSolutionPoint(
                fixedSolutionPoint: fixedSolutionPoint,
                leftPoint: &leftPoint,
                rightPoint: &rightPoint
            )
        }
        
        return solutionSum
    }

    func avoidFixedSolutionPoint(fixedSolutionPoint: Int, leftPoint: inout Int, rightPoint: inout Int) {
        if fixedSolutionPoint == leftPoint {
            leftPoint += 1
        }
        
        if fixedSolutionPoint == rightPoint {
            rightPoint -= 1
        }
    }

    struct SolutionSum {
        let absSum: Int
        let selectedSolutionIndexes: [Int]
    }
}

private func readSolutions() -> [Int] {
    let line = readLine()!
    var solutions = line.split(separator: " ").map { Int($0)! }
    
    solutions.sort()
    return solutions
}
