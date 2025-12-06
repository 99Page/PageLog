//
//  Solver14501.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver14501 {
    let remainDays: Int
    
    /// {Index} 일에 잡힌 상담에 대한 정보들.
    let times: [Int]
    let costs: [Int]
    
    /// {Index} 일에 얻을 수 있는 최대 금액.
    /// Index 1부터 시작
    var mem: [Int]
    
    /// 퇴사 일은 최대 15일
    /// 상담의 최대 기간은 1000일.
    /// 따라서 상담이 끝나는 마지막 기간은 1015일
    let maxEndDay = 1015
    
    init() {
        self.remainDays = Int(readLine()!)!
        
        var times: [Int] = [0]
        var costs: [Int] = [0]
        
        (0..<remainDays).forEach { _ in
            let input: [Int] = readArray()
            times.append(input[0])
            costs.append(input[1])
        }
        
        self.times = times
        self.costs = costs
        self.mem = Array(repeating: 0, count: maxEndDay + 1)
    }
    
    /// 문제 해결을 위한 최초 진입 지점
    mutating func solve() {
        
        for day in 1...remainDays {
            let time = times[day]
            let cost = costs[day]
            
            let endDay = day + time - 1
            
            mem[day] = max(mem[day - 1], mem[day])
            mem[endDay] = max(mem[endDay], mem[endDay - time] + cost)
        }
        
        print(mem[remainDays])
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let array = line.split(separator: " ").map {
        T(String($0))!
    }
    return array
}

