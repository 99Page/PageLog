//
//  Solver7570.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/15/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

//5
//4 3 1 2 5
//답: 2

//10
//5 6 1 2 4 10 8 9 7 3
//답: 6

//2
//2 1

//2
//1 2

struct Solver7570 {
    let kidCount: Int
    let initialKidSequence: [Int]
    var mem: [Int]
    
    init() {
        self.kidCount = Int(readLine()!)!
        self.initialKidSequence = readArray()
        self.mem = Array(repeating: 0, count: kidCount + 1)
    }
    
    mutating func solve() {
        
        let result = longestContinuousIncreasingSubsequence()
        
        print(kidCount - result)
    }

    
    mutating func longestContinuousIncreasingSubsequence() -> Int {
        var maxLength = 1
        
        for sequence in initialKidSequence {
            mem[sequence] = mem[sequence - 1] + 1
            maxLength = max(maxLength, mem[sequence])
        }
        
        return maxLength
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}



