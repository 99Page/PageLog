//
//  Solver14425.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/9/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation


struct Solver14425 {
    
    var childs: [String] = []
    let n: Int
    let m: Int
    var result = 0
    var parents: Set<String> = []
    
    init() {
        let input: [Int] = readArray()
        self.n = input[0]
        self.m = input[1]
    }
    
    mutating func solve() {
        (0..<n).forEach { _ in
            let parent = readLine()!
            parents.insert(parent)
        }
        
        (0..<m).forEach { _ in
            let child = readLine()!
            childs.append(child)
        }
        
        for i in 0..<m {
            let child = childs[i]
            
            if parents.contains(child) {
                result += 1
            }
        }
        
        print(result)
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

