//
//  main.swift
//  2024.CPC
//
//  Created by 노우영 on 9/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// 높이 0부터 원하는 높이까지
/// 배열의 인덱스를 하나씩 늘려가며 memoization을 채울 수 있으니
/// DP를 활용할만한 문제

let modular = 1_000_000_007
let input: [Int] = readArray()

let cupCount = input[0]
let targetHeight = input[1]
let cups: [Int] = readArray()

/// 배열의 공간을 미리 할당해두면 나중에 append 연산을 줄일 수 있어 더 효율적이다.
var heightMem: [Int] = Array(repeating: 0, count: targetHeight + 1)
heightMem[0] = 1

solve()

func solve() {
    
    for height in 1...targetHeight {
        calculateWaysToReachHeight(of: height)
    }
    
    print(heightMem[targetHeight])
}

func calculateWaysToReachHeight(of height: Int) {
    for cup in cups {
        let remainHeight = height - cup
        if remainHeight >= 0 {
            heightMem[height] = (heightMem[height] + heightMem[remainHeight]) % modular
        }
    }
}

func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

