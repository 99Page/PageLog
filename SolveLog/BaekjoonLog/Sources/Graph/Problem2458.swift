//
//  Problem2458.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Problem2458 {
    
    // 0 비교 불가
    // [i][j] = -1 -> i가 더 작음
    // [i][j] = 1 -> i가 더큼
    var compareTable: [[Int]] = []
    var peopleCount = 0
    var isVisited: [Bool] = []
    
    typealias Tallers = Set<Int>
    
    mutating func solve() {
        readAndInit()
        fillTable()
        printKnownSequence()
    }
    
    func printKnownSequence() {
        var count = 0
        
        for i in 1...peopleCount {
            var compareCount = 0
            
            for j in 1...peopleCount {
                if compareTable[i][j] != 0 { compareCount += 1 }
            }
            
            if compareCount == peopleCount - 1 {
                count += 1
            }
        }
        
        print(count)
    }
    
    mutating func fillTable() {
        for k in 1...peopleCount {
            for i in 1...peopleCount {
                for j in 1...peopleCount {
                    // i < k && k < j
                    if compareTable[i][k] == -1 && compareTable[k][j] == -1 {
                        compareTable[i][j] = -1
                        compareTable[j][i] = 1
                    }
                    
                    if compareTable[i][k] == 1 && compareTable[k][j] == 1 {
                        compareTable[i][j] = 1
                        compareTable[j][i] = -1
                    }
                }
            }
        }
    }
    
    mutating func readAndInit() {
        let meta: [Int] = readArray()
        peopleCount = meta[0]
        let compareCount = meta[1]
        
        compareTable = Array(repeating: Array(repeating: 0, count: peopleCount + 1), count: peopleCount + 1)
        
        (0..<compareCount).forEach { _ in
            let compare: [Int] = readArray()
            let s = compare[0]
            let t = compare[1]
            compareTable[s][t] = -1
            compareTable[t][s] = 1
        }
        
        isVisited = Array(repeating: false, count: peopleCount + 1)
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


