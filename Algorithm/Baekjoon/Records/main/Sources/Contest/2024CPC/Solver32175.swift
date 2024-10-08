//
//  Solver32175.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver32175 {
    /// 높이 0부터 원하는 높이까지
    /// 배열의 인덱스를 하나씩 늘려가며 memoization을 채울 수 있으니
    /// DP를 활용할만한 문제

    let modular = 1_000_000_007

    let cupCount: Int
    let targetHeight: Int
    let cups: [Int]

    /// 배열의 공간을 미리 할당해두면 나중에 append 연산을 줄일 수 있어 더 효율적이다.
    var heightMem: [Int]
    
    init() {
        let input: [Int] = readArray()
        self.cupCount = input[0]
        self.targetHeight = input[1]
        self.cups = readArray()
        self.heightMem = Array(repeating: 0, count: targetHeight + 1)
    }

    mutating func solve() {
        heightMem[0] = 1
        
        for height in 1...targetHeight {
            calculateWaysToReachHeight(of: height)
        }
        
        print(heightMem[targetHeight])
    }

    mutating func calculateWaysToReachHeight(of height: Int) {
        for cup in cups {
            let remainHeight = height - cup
            if remainHeight >= 0 {
                heightMem[height] = (heightMem[height] + heightMem[remainHeight]) % modular
            }
        }
    }
}


private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

