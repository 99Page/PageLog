//
//  Solver5052.swift
//  baekjoon-solve
//
//  Created by 노우영 on 5/20/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver5052 {
    let testCase: Int
    
    var result: [String] = []
    init() {
        self.testCase = Int(readLine()!)!
    }
    
    mutating func solve() {
        (0..<testCase).forEach { _ in
            solveCase()
        }
        
        printResult()
    }
    
    private func printResult() {
        let joined = result.joined(separator: "\n")
        print(joined)
    }
    
    mutating func solveCase() {
        let numberCount = Int(readLine()!)!
        let numbers = readNumbers(numberCount)
        let sortedNumbers = numbers.sorted()
        
        for index in 0..<sortedNumbers.count - 1 {
            let current = sortedNumbers[index]
            let next = sortedNumbers[index + 1]
            
            if next.hasPrefix(current) {
                result.append("NO")
                return
            }
        }
        
        result.append("YES")
    }
    
    private func readNumbers(_ k: Int) -> [String] {
        var result: [String] = []
        
        (0..<k).forEach { _ in
            result.append(readLine()!)
        }
        
        return result
    }
}
