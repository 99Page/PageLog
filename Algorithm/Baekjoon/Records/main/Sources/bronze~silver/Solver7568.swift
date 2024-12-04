//
//  Solver7568.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation


struct Solver7568 {
    let peopleCount: Int
    
    /// 2차원 배열의 Index: 사람에 대한 인덱스
    /// 1차원 배열의 Index 0: Weight
    /// 1차원 배열의 Index 1: Height
    let physicals: [[Int]]
    
    init() {
        self.peopleCount = Int(readLine()!)!
        
        var physicals: [[Int]] = []
        
        (0..<peopleCount).forEach { _ in
            let physical: [Int] = readArray()
            physicals.append(physical)
        }
        
        
        self.physicals = physicals
    }
    
    /// 문제 풀이를 위한 최초 진입 지점
    mutating func solve() {
        var result: [Int] = []
        
        for i in physicals.indices {
            /// 덩치 등수는 1부터 시작
            var score = 1
            
            for j in physicals.indices {
                if i == j { continue }
                
                if isLargetPhysical(than: i, at: j) {
                    score += 1
                }
            }
            
            result.append(score)
        }
        
        print(result.joinedString())
    }
    
    
    /// 두 대상의 덩치를 비교합니다.
    /// - Parameters:
    ///   - i: 덩치를 비교할 첫번째 대상
    ///   - j: 덩치를 비교할 첫번째 대상
    /// - Returns: i의 덩치가 더 크면 true, 그 외엔 false
    private func isLargetPhysical(than j: Int, at i: Int) -> Bool {
        physicals[i][0] > physicals[j][0]
        && physicals[i][1] > physicals[j][1]
    }
}

private extension Array where Element: LosslessStringConvertible {
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let array = line.split(separator: " ").map {
        T(String($0))!
    }
    return array
}
