//
//  Solver1406.swift
//  baekjoon-solve
//
//  Created by 노우영 on 9/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

/// 문자열 중간에 계속 삽입을 하는 문제
/// 한개 문자열에서 계속 삽입을 하면 매번 O(n^2)
/// 커서의 '왼쪽' 과 '오른쪽' 이라는 형식으로 나눌 수 있으니 이를 처리 
struct Solver1406 {
    var leftStack = [Character]()
    var rightStack = [Character]()
    var orderCount = 0
    
    mutating func solve() {
        readInitialString()
        self.orderCount = Int(readLine()!)!
        edit()
        
        let result = leftStack + rightStack.reversed()
        print(String(result))
    }
    
    mutating func edit() {
        (0..<orderCount).forEach { _ in
            let order = readLine()!
            handleOrder(order)
        }
    }
    
    mutating func handleOrder(_ order: String) {
        let command = order.first!
        
        switch command {
        case "L":
            if !leftStack.isEmpty {
                let last = leftStack.removeLast()
                rightStack.append(last)
            }
        case "D":
            if !rightStack.isEmpty {
                let last = rightStack.removeLast()
                leftStack.append(last)
            }
        case "B":
            if !leftStack.isEmpty {
                leftStack.removeLast()
            }
        case "P":
            let newCharacter = order.last!
            leftStack.append(newCharacter)
        default:
            break
        }
    }
    
    mutating func readInitialString() {
        self.leftStack = [Character](readLine()!)
    }
}
