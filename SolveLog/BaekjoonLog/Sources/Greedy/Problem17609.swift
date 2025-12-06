//
//  File1.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Problem17609 {
    
    mutating func solve() {
        let stringCount = Int(readLine()!)!
        
        (0..<stringCount).forEach { _ in
            let target = [Character](readLine()!)
            print(determine(target))
        }
    }
    
    func determine(_ target: [Character]) -> Int {
        var left = 0
        var right = target.count - 1
        
        var rollBackLeft = 0
        var rollBackRight = 0
        var didDeleteLeft = false
        var didDeleteRight = false
        var result = 0
        
        while left <= right {
            if target[left] == target[right] {
                left += 1
                right -= 1
            } else if !didDeleteLeft {
                rollBackLeft = left // 오른쪽 검사를 위한 롤백
                rollBackRight = right
                
                left += 1 // 삭제를 위해, 왼쪽만 우선 이동 시킴.
                result = 1 // 삭제를 진행한 경우이
                didDeleteLeft = true
                
            } else if !didDeleteRight { // 오른쪽 삭제 진행해야하는 경우
                left = rollBackLeft
                right = rollBackRight
                right -= 1
                rollBackLeft = 0
                rollBackRight = 0
                didDeleteRight = true
            } else { // 유사 회문이 아님.
                return 2
            }
        }
        
        return result
    }
}
