//
//  Solver2884.swift
//  bronze.to.silver.solve
//
//  Created by 노우영 on 9/30/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver2884 {
    let testCase: Int
    
    init() {
        self.testCase = readArray()[0]
    }

    func solve() {
        (0..<testCase).forEach { _ in
            solveTestCase()
        }
    }

    func solveTestCase() {
        var input: [Int] = readArray()
        let studentCount = input.removeFirst()
        let sum = input.reduce(0, +)
        let mean = sum / studentCount
        
        var goodStudentCount = 0
        
        for score in input  {
            if score > mean {
                goodStudentCount += 1
            }
        }
        
        let multiplier = pow(10.0, 5.0) // 10의 3제곱
        let ratio = Double(Double(goodStudentCount) / Double(studentCount)) * 100
        let roundedRatio = (ratio * multiplier).rounded() / multiplier
        
        let result = String(format: "%.3f", roundedRatio)
        print("\(result)%")
    }
}


private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

