//
//  Concurrency.swift
//
//  Created by 노우영 on 6/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

let n = readNumberOfSolution()
var solutions: [Int] = []

var minValuePointer: (Int, Int) = (0, 0)
var minValue: Int = .max

readSolutions()
checkSum(leftPointer: 0, rightPointer: solutions.count - 1)

print("\(solutions[minValuePointer.0]) \(solutions[minValuePointer.1])")

func checkSum(leftPointer: Int, rightPointer: Int) {
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



func readSolutions() {
    let solutionsInput = readLine()
    let splitedSolutions = solutionsInput?.split(separator: " ").map { input in
        Int(input)
    }
    
    for solution in splitedSolutions! {
        solutions.append(solution!)
    }
}

func readNumberOfSolution() -> Int {
    let result = readLine()
    return Int(result ?? "") ?? 0
}
