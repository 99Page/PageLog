//
//  Solver1245.swift
//  baekjoon-solve
//
//  Created by 노우영 on 9/3/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver1253 {
    
    let numberCount: Int
    let numbers: [Int]
    var sumSet: Set<Int> = []
    var combinations: [Int: [[Int]]] = [:]
    
    init() {
        self.numberCount = Int(readLine()!)!
        self.numbers = readArray()
    }
    
    mutating func solve() {
        
        var goodNumberCount = 0
        
        for i in 0..<numberCount {
            for j in i+1..<numberCount {
                let sum = numbers[i] + numbers[j]
                sumSet.insert(sum)
                combinations[sum, default: []].append([i, j])
            }
        }
        
        for (index, number) in numbers.enumerated() {
            if combinations[number] == nil { continue }
            
            for combination in combinations[number]! {
                
                if !combination.contains(index) {
                    goodNumberCount += 1
                    break
                }
            }
        }
        
        print(goodNumberCount)
    }
}


private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

