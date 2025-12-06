//
//  Solver4949.swift
//  baekjoon-solve
//
//  Created by 노우영 on 8/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver4949 {
    
    func solve() {
        
        var results: [String] = []
        
        while true {
            let input = readLine()!
            
            if input == "." {
                break
            }
            
            if isBalancedString(input) {
                results.append("yes")
            } else {
                results.append("no")
            }
        }
        
        
        print(results.joined(separator: "\n"))
    }
    
    func isBalancedString(_ string: String) -> Bool {
        
        var parenthesisQueue = [Character]()
        
        
        for char in string {
            if char == "(" || char == "[" {
                parenthesisQueue.append(char)
            }
            
            if (char == ")" || char == "]") && parenthesisQueue.isEmpty {
                return false
            }
            
            if char == ")" {
                let lastChar = parenthesisQueue.removeLast()
                
                if lastChar != "(" {
                    return false
                }
            }
            
            if char == "]" {
                let lastChar = parenthesisQueue.removeLast()
                if lastChar != "[" {
                    return false
                }
            }
        }
        
        return parenthesisQueue.isEmpty
    }
}

private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}
