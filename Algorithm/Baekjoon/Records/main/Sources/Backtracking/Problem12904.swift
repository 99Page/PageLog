//
//  Problem12904.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Problem12904 {
    
    var initial = ""
    var target = ""
    
    mutating func solve() {
        read()
        makeTarget()
    }
    
    mutating func makeTarget() {
        var queue = Queue<String>()
        var result = 0
        var visit: Set<String> = []
        queue.enqueue(target)
        var count = 0
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            count += 1
            if current == initial {
                result = 1
                break
            }
            
            if current.count == initial.count {
                continue
            }
            
            
            if current.hasSuffix("A") {
                let case1 = String(current.dropLast())
                
                if !visit.contains(case1) {
                    queue.enqueue(case1)
                    visit.insert(case1)
                }
            }
            
            if current.hasSuffix("B") {
                let case2 = "\(String(String(current.dropLast()).reversed()))"
                
                if !visit.contains(case2) {
                    queue.enqueue(case2)
                    visit.insert(case2)
                }
            }
        }
        
        print(result)
    }
    
    mutating func read() {
        initial = readLine()!
        target = readLine()!
    }
    
    struct Queue<Element> {
        private var inStack = [Element]()
        private var outStack = [Element]()
        
        /// 큐가 비어있는지 여부를 반환합니다.
        var isEmpty: Bool {
            inStack.isEmpty && outStack.isEmpty
        }

        /// 큐에 있는 요소의 총 개수를 반환합니다.
        var count: Int {
            inStack.count + outStack.count
        }

        /// 큐의 첫 번째 요소를 제거하지 않고 반환합니다.
        var peek: Element? {
            if outStack.isEmpty {
                return inStack.first
            }
            return outStack.last
        }
        
        /// 큐에 요소를 추가합니다.
        /// - Parameter newElement: 큐에 삽입할 요소
        mutating func enqueue(_ newElement: Element) {
            inStack.append(newElement)
        }
        
        /// 큐에서 요소를 제거하고 반환합니다.
        /// - Returns: FIFO 순서로 제거된 요소. 큐가 비어있다면 nil
        mutating func dequeue() -> Element? {
            if outStack.isEmpty {
                outStack = inStack.reversed()
                inStack.removeAll()
            }
            
            return outStack.popLast()
        }
    }
}



