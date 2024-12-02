//
//  Solver5904.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/2/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver5904 {
    let targetIndex: Int
    
    init() {
        self.targetIndex = Int(readLine()!)!
    }
    
    /// 문제 해결을 위한 최초 진입 지점입니다.
    func solve() {
        var length = 3
        var sequence = 1
        
        /// 현재 길이가 찾으려는 캐릭터의 위치 이상일 때까지 반복
        while length <= targetIndex {
            length = length * 2 + (sequence + 3)
            
            sequence += 1
        }
        
        divide(currentLength: length, sequence: sequence - 1, targetIndex: targetIndex, isMiddleFormular: false)
    }
    
    /// 수열을 분할하고, 출력합니다.
    /// - Parameters:
    ///   - currentLenght: 현재 수열의 길이
    ///   - sequence: 현재 수열의 순서. S(n)에서의
    ///   - targetIndex: 찾으려는 캐릭터의 위치
    ///   - isMiddleFormular: 현재 보고 있는 문자열이 중앙의 수식인지 판별하는 bool 값.
    ///
    /// S(n) = S(n-1) + m(n) + S(n-1)로 구성됩니다.
    /// m(n) = o가 k+2개인 수열을 의미합니다.
    /// 각 시행마다 전체 길이를 m과 o를 판별 가능할 때까지 3등분 후
    /// 기저 케이스에서 출력합니다.
    func divide(currentLength: Int, sequence: Int, targetIndex: Int, isMiddleFormular: Bool) {
        
        /// 현재 수열이 m(n)에 해당하는 경우
        guard !isMiddleFormular else {
            printAtMiddleFormular(targetIndex: targetIndex)
            return
        }
        
        /// 현재 수열이 S(0)인 경우.
        guard sequence > 0 else {
            printAtFirstSequence(targetIndex: targetIndex)
            return
        }
        
        /// S(n) = S(n-1) + M(n) + S(n-1)
        /// --------------------
        /// (1)         (2)        (3)       (4)
        /// M(n)의 길이 = sequence + 3
        let mooLength = sequence + 3
        
        /// S(n-1)의 길이 = (S(n) - M(n)) / 2
        let previousLength = (currentLength - mooLength) / 2
        
        /// (4)의 시작 위치 = (1)의 길이 - (2)의 길이 - (3)의 길이
        let tailThreshold = currentLength - previousLength
        
        
        if targetIndex <= previousLength { /// (2)번인 경우
            divide(currentLength: previousLength, sequence: sequence - 1, targetIndex: targetIndex, isMiddleFormular: false)
        } else if targetIndex > tailThreshold { /// (3)번인 경우
            divide(currentLength: previousLength, sequence: sequence - 1, targetIndex: targetIndex - tailThreshold, isMiddleFormular: false)
        } else { /// (4)번인 경우
            divide(currentLength: mooLength, sequence: sequence, targetIndex: targetIndex - previousLength, isMiddleFormular: true)
        }
    }
    
    /// S(0) 수열에서 주어진 위치에 있는 캐릭터를 출력합니다. 첫번째만 m입니다.
    /// - Parameters:
    ///   - targetIndex: 확인하려는 캐릭터의 위치
    private func printAtFirstSequence(targetIndex: Int) {
        if targetIndex == 1 {
            print("m")
        } else {
            print("o")
        }
    }
    
    /// MiddleFormular에서 주어진 위치에 있는 캐릭터를 출력합니다. 제일 앞자리만 m입니다.
    /// - Parameters:
    ///   - targetIndex: 판별하는 캐릭터의 위치
    private func printAtMiddleFormular(targetIndex: Int) {
        if targetIndex == 1{
            print("m")
        } else {
            print("o")
        }
    }
}
