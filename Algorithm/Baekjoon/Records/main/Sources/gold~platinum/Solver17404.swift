//
//  Solver17404.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// 배열을 step by step으로 채워가며, 이전 단계의 계산 결과를 활용할 수 있는 문제 -> DP
struct Solver17404 {
    var mem: [[Int]]
    let houseCount: Int
    
    var colorCost: [[Int]]
    
    init() {
        let houseCount = Int(readLine()!)!
        self.houseCount = houseCount
        self.colorCost = readGrid(houseCount)
        
        
        let colorCount = Color.allCases.count
        
        self.mem = Array(repeating: Array(repeating: .max, count: colorCount), count: houseCount - 1)
    }
    
    mutating func solve() {
        var answer: Int = .max
        
        for startColor in Color.allCases {
            
            /// 시작점, 종료점을 미리 선택합니다.
            let endColors = startColor.anotherColors
            
            for endColor in endColors {
                mem[0][0] = .max
                mem[0][1] = .max
                mem[0][2] = .max
                
                /// 최초 mem에 시작점+종료점을 더한 값을 저장합니다.
                mem[0][startColor.rawValue] = colorCost[0][startColor.rawValue] + colorCost[houseCount - 1][endColor.rawValue]
                
                fillMem()
                
                for color in Color.allCases {
                    if color != endColor {
                        let value = mem[houseCount - 2][color.rawValue]
                        answer = min(answer, value)
                    }
                }
            }
        }
        
        print(answer)
    }
    
    mutating func fillMem() {
        for index in 1..<houseCount - 1 {
            mem[index][0] = .max
            mem[index][1] = .max
            mem[index][2] = .max
            
            let redMin = min(mem[index-1][1], mem[index-1][2])
            
            if redMin != .max {
                mem[index][0] = redMin + colorCost[index][0]
            }
            
            let blueMin = min(mem[index-1][0], mem[index-1][2])
            
            if blueMin != .max {
                mem[index][1] = blueMin + colorCost[index][1]
            }
            
            let greedMin = min(mem[index-1][0], mem[index-1][1])
            if greedMin != .max {
                mem[index][2] = greedMin + colorCost[index][2]
            }
        }
    }
    
    enum Color: Int, CaseIterable {
        case red = 0
        case green = 1
        case blue = 2
        
        var anotherColors: [Color] {
            switch self {
            case .red:
                return [.green, .blue]
            case .green:
                return [.red, .blue]
            case .blue:
                return [.red, .green]
            }
        }
    }
}

private func readGrid<T: LosslessStringConvertible>(_ k: Int) -> [[T]] {
    var result: [[T]] = []
    
    (0..<k).forEach { _ in
        let array: [T] = readArray()
        result.append(array)
    }
    
    return result
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


