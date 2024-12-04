//
//  Solver9461.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver9461 {
    var maxLenghts: [Int] = [1, 1, 1, 2, 2, 3, 4]
    let maxTarget = 100
    let testCase: Int
    
    init() {
        self.testCase = Int(readLine()!)!
    }
    
    mutating func solve() {
        fillMaxLenghts()
        
        (0..<testCase).forEach { _ in
            let n = Int(readLine()!)!
            print(maxLenghts[n - 1])
        }
    }
    
    private mutating func fillMaxLenghts() {
        for index in maxLenghts.count-1..<maxTarget {
            let newLength = maxLenghts[index] + maxLenghts[index - 4]
            maxLenghts.append(newLength)
        }
    }
}
