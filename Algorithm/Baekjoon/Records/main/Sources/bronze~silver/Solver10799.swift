//
//  Solver10799.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/27/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver10799 {
    let parentheses: [Character]
    
    /// index: 쇠막대기의 높이 정보. 가장 밑에 배치된 쇠막대기기의 인덱스는 0.
    /// value: 해당 막대기 안에 있는 레이저의 개수
    var lazerCount: [Int] = Array(repeating: 0, count: 100_000)
    
    init() {
        self.parentheses = [Character](readLine()!)
    }
    
    mutating func solve() {
        var level = -1
        var result = 0
        
        for (index, parenthesis) in parentheses.enumerated() {
            if parenthesis == "(" {
                level += 1
            } else {
                level -= 1
                
                /// `()`가 연속인 경우는 레이저입니다.
                if parentheses[index-1] == "(" {
                    incrementLazerCount(upTo: level)
                } else {
                    /// 막대기 안의 lazer의 수가 n개인 경우 막대기는 n+1개로 나눠집니다.
                    let splitedCount = lazerCount[level + 1] + 1
                    result += splitedCount
                    
                    /// 레이저를 이용해 나눠진 막대기를 더한 후, 해당 값을 초기화합니다.
                    lazerCount[level + 1 ] = 0
                }
            }
        }
        
        print(result)
    }
    
    /// 레이저의 수를 증가시킵니다.
    mutating func incrementLazerCount(upTo level: Int) {
        guard level >= 0 else { return }

        // 만약 lazerCount가 [0...n]까지 있다면, level이 n보다 큰 경우를 대비해 처리
        let upperBound = min(level, lazerCount.count - 1)

        for index in 0...upperBound {
            lazerCount[index] += 1
        }
    }
}

private extension String {
    /// 문자열의 특정 인덱스에 있는 문자를 반환하는 함수
    /// - Parameter index: 반환할 문자 위치의 인덱스
    /// - Returns: 해당 위치에 있는 문자 (인덱스가 유효하지 않으면 nil 반환)
    func getCharacter(at index: Int) -> Character? {
        /// 인덱스가 유효한지 확인
        guard index >= 0 && index < self.count else { return nil }
        
        /// String.Index로 변환
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        
        /// 해당 위치의 문자 반환
        return self[stringIndex]
    }
}

