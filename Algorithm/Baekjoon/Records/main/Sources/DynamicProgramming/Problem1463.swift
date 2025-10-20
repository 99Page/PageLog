//
//  Problem1463.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/20/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

// 메모리(Byte)
// 8x1_000_00 = 8_000_000 = 8000KB = 8MB
// queue 최악의 경우까지 16MB
struct Problem1463 {
    var mem = Array(repeating: -1, count: 1_000_001)
    
    mutating func solve() {
        let x = Int(readLine()!)!
        var queue = Queue<Int>()
        queue.enqueue(x)
        mem[x] = 0
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            if current == 1 {
                break
            }
            
            let nextCount = mem[current] + 1
            
            if current % 3 == 0 && mem[current / 3] == -1 {
                mem[current / 3] = nextCount
                queue.enqueue(current / 3)
            }
            
            if current % 2 == 0 && mem[current / 2] == -1 {
                mem[current / 2] = nextCount
                queue.enqueue(current / 2)
            }
            
            if current - 1 > 0  && mem[current - 1] == -1 {
                mem[current - 1] = nextCount
                queue.enqueue(current - 1)
            }
        }
        
        print(mem[1])
    }
    
    public struct Queue<Element> {
        private var inStack = [Element]()
        private var outStack = [Element]()
        
        public init() { }
        
        /// 큐가 비어있는지 여부를 반환합니다.
        public var isEmpty: Bool {
            inStack.isEmpty && outStack.isEmpty
        }

        /// 큐에 있는 요소의 총 개수를 반환합니다.
        public var count: Int {
            inStack.count + outStack.count
        }

        /// 큐의 첫 번째 요소를 제거하지 않고 반환합니다.
        public var peek: Element? {
            if outStack.isEmpty {
                return inStack.first
            }
            return outStack.last
        }
        
        /// 큐에 요소를 추가합니다.
        /// - Parameter newElement: 큐에 삽입할 요소
        public mutating func enqueue(_ newElement: Element) {
            inStack.append(newElement)
        }
        
        /// 큐에서 요소를 제거하고 반환합니다.
        /// - Returns: FIFO 순서로 제거된 요소. 큐가 비어있다면 nil
        public mutating func dequeue() -> Element? {
            if outStack.isEmpty {
                outStack = inStack.reversed()
                inStack.removeAll()
            }
            
            return outStack.popLast()
        }
    }

}
