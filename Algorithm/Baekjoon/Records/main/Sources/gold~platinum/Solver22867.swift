//
//  Solver22867.swift
//  baekjoon-solve
//
//  Created by 노우영 on 8/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver22867 {
    
    let buses: [Bus]
    
    init() {
        let busCount = Int(readLine()!)!
        
        var buses: [Bus] = []
        
        (0..<busCount).forEach { _ in
            let busInput: [String] = readArray()
            let bus = Bus(startTime: busInput[0], endTime: busInput[1])
            buses.append(bus)
        }
        
        self.buses = buses
    }
    
    mutating func solve() {
        // 시작/종료 시각 배열 생성 후 정렬
        var starts = buses.map { $0.startTime }
        var ends   = buses.map { $0.endTime }
        starts.sort()
        ends.sort()

        // [start, end) 규칙: 같은 시각이면 종료를 먼저 처리
        var i = 0, j = 0
        var cur = 0, ans = 0
        
        while i < starts.count && j < ends.count {
            if starts[i] < ends[j] {
                cur += 1
                if cur > ans { ans = cur }
                i += 1
            } else {
                cur -= 1
                j += 1
            }
        }

        print(ans)
    }

    
    struct Bus: Comparable {
        let startTime: String
        let endTime: String
        
        static func < (lhs: Solver22867.Bus, rhs: Solver22867.Bus) -> Bool {
            if lhs.endTime != rhs.endTime {
                return lhs.endTime < rhs.endTime
            } else {
                return lhs.startTime < rhs.startTime
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

