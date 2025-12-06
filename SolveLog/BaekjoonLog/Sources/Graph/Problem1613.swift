//
//  Problem1613.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/5/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

// 위상 정렬 문제니까 DAG인지 확인 필요.
// DAG: 유향 비순환 그래프
struct Problem1613 {
    
    var nodeCount = 0
    var edgeCount = 0
    
    var inDegree: [Int: Set<Int>] = [:]
    var outDegree: [Int: Set<Int>] = [:]
    
    var preevent: [Int: Set<Int>] = [:]
    
    mutating func solve() {
        readInfo()
        runTopologySort()
        determineSequence()
    }
    
    func determineSequence() {
        let count = Int(readLine()!)!
        var result: [Int] = []
        
        (0..<count).forEach { _ in
            let event: [Int] = readArray()
            let e1 = event[0]
            let e2 = event[1]
            
            if preevent[e2, default: []].contains(e1) {
                result.append(-1)
            } else if preevent[e1, default: []].contains(e2) {
                result.append(1)
            } else {
                result.append(0)
            }
        }
        
        print(result.joinedString(with: "\n"))
    }
    
    mutating func runTopologySort() {
        var queue = Queue<Int>()
        
        for (key, value) in inDegree {
            if value.isEmpty { queue.enqueue(key) }
        }
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            for next in outDegree[current, default: []] {
                preevent[next]?.insert(current)
                let currentPreset = preevent[current, default: []]
                preevent[next]?.formUnion(currentPreset)
                inDegree[next]?.remove(current)
                
                if inDegree[next, default: []].isEmpty {
                    queue.enqueue(next)
                }
            }
        }
    }
    
    mutating func readInfo() {
        let metaInfo: [Int] = readArray()
        nodeCount = metaInfo[0]
        edgeCount = metaInfo[1]
        
        (1...nodeCount).forEach { event in
            inDegree[event] = []
            outDegree[event] = []
            preevent[event] = []
        }
        
        (0..<edgeCount).forEach { _ in
            let sequence: [Int] = readArray()
            let pre = sequence[0]
            let post = sequence[1]
            outDegree[pre, default: []].insert(post)
            inDegree[post, default: []].insert(pre)
        }
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

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

private extension Array where Element: LosslessStringConvertible {
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}
