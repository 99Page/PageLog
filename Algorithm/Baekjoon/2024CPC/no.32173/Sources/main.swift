//
//  main.swift
//  2024.CPC
//
//  Created by 노우영 on 9/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// Brute force로는 time out
/// Backtracking도 비슷함.. 중복 케이스를 걸러내는 방법은 없음
/// Greedy는?
///
/// 내 앞의 행복도 합보다 크다면 앞으로 가는걸로.

let studentCount = Int(readLine()!)!
let satisfactions: [Int] = readArray()

solve()

func solve() {
    var result = 0
    var satisfactionSum = 0
    
    for satisfaction in satisfactions {
        let newSatisfaction = satisfaction - satisfactionSum
        
        if newSatisfaction > result {
            result = newSatisfaction
        }
        
        satisfactionSum += satisfaction
    }
    
    print(result)
}


func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

