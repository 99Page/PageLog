//
//  Problem15486.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/21/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Problem15486 {
    var counselCount = 0
    var cost: [Int] = [0]
    var day: [Int] = [0]
    var mem: [Int] = [0]
    
    mutating func solve() {
        read()
        
        for i in 1...counselCount {
            mem[i] = max(mem[i], mem[i-1])
            let d = day[i] - 1
            guard i+d <= counselCount else { continue }
            mem[i+d] = max(mem[i-1] + cost[i], mem[i+d])
        }
        
        print(mem[counselCount])
    }
    
    mutating func read() {
        counselCount = Int(readLine()!)!
        
        (0..<counselCount).forEach { _ in
            let counsel: [Int] = readArray()
            let d = counsel[0]
            let c = counsel[1]
            day.append(d)
            cost.append(c)
            mem.append(0)
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

