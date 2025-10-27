//
//  Problem1414.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/27/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Problem1414 {
    var numberOfComputer = 0
    var edges: [Edge] = []
    
    mutating func solve() {
        read()
        donate()
    }
    
    mutating func donate() {
        var sumOfDonate = 0
        var heap = Heap<Edge>.minHeap()
        
        var linkCount = 0
        var unionFinder = UnionFindSolver(arrayIndexBase: .zero(nodeCount: numberOfComputer))
        
        for edge in edges {
            heap.insert(edge)
        }
        
        while !heap.isEmpty {
            let edge = heap.pop()!
            
            if !unionFinder.isConnected(edge.src, edge.dest) {
                unionFinder.union(edge.src, edge.dest)
                linkCount += 1
            } else {
                sumOfDonate += edge.cost
            }
        }
        
        
        if linkCount == numberOfComputer - 1 {
            print(sumOfDonate)
        } else {
            print("-1")
        }
    }
    
    mutating func read() {
        numberOfComputer = Int(readLine()!)!
        
        (0..<numberOfComputer).forEach { i in
            let edgeInput = [Character](readLine()!)
            
            for (j, cc) in edgeInput.enumerated() {
                guard cc != "0" else { continue }
                
                let cost: Int
                
                if cc.isUppercase {
                    cost = Int(cc.asciiValue!) - Int(Character("A").asciiValue!) + 27
                } else {
                    cost = Int(cc.asciiValue!) - Int(Character("a").asciiValue!) + 1
                }
                
                let edge = Edge(src: i, dest: j, cost: cost)
                edges.append(edge)
            }
        }
    }
    
    struct UnionFindSolver {
        private var parent: [Int]
        private var rank: [Int]
        private let arrayIndexBase: ArrayIndexBase
        
        init(arrayIndexBase: ArrayIndexBase) {
            self.arrayIndexBase = arrayIndexBase
            let arraySize = arrayIndexBase.arraySize
            self.parent = Array(0..<arraySize) // 각 노드는 자신을 부모로 설정
            self.rank = Array(repeating: 0, count: arraySize) // 모든 노드의 랭크는 0으로 초기화
        }
        
        mutating func find(_ node: Int) -> Int {
            if parent[node] != node {
                parent[node] = find(parent[node])
            }
            
            return parent[node]
        }
        
        mutating func union(_ node1: Int, _ node2: Int) {
            let root1 = find(node1)
            let root2 = find(node2)
            
            if root1 == root2 {
                return
            }
            
            // 랭크 기반 병합: 더 높은 랭크를 가진 트리를 루트로 설정
            if rank[root1] > rank[root2] {
                parent[root2] = root1
            } else if rank[root1] < rank[root2] {
                parent[root1] = root2
            } else {
                parent[root2] = root1
                rank[root1] += 1
            }
        }
        
        mutating func isConnected(_ node1: Int, _ node2: Int) -> Bool {
            return find(node1) == find(node2)
        }
        
        enum ArrayIndexBase {
            case zero(nodeCount: Int)
            case one(nodeCount: Int)
            
            var arraySize: Int {
                switch self {
                case .zero(let nodeCount):
                    return nodeCount
                case .one(let nodeCount):
                    return nodeCount + 1
                }
            }
            
            var addtionalIndex: Int {
                switch self {
                case .zero:
                    return 0
                case .one:
                    return 1
                }
            }
        }
    }

    
    struct Edge: Comparable {
        static func < (lhs: Problem1414.Edge, rhs: Problem1414.Edge) -> Bool {
            lhs.cost < rhs.cost
        }
        
        let src: Int
        let dest: Int
        let cost: Int
    }
    
    struct Heap<Element: Comparable> {
        private let comparator: (Element, Element) -> Bool
        private(set) var elements: [Element] = []
        
        init(comparator: @escaping (Element, Element) -> Bool) {
            self.comparator = comparator
        }
        
        var isEmpty: Bool {
            elements.isEmpty
        }
        
        func peek() -> Element? {
            elements.first
        }
        
        /// - Complexity: O(log n)
        mutating func insert(_ element: Element) {
            elements.append(element)
            let insertedIndex = elements.count - 1
            siftUp(startIndex: insertedIndex)
        }
        
        mutating private func siftUp(startIndex: Int) {
            var currentIndex = startIndex
            
            while hasHigherPriorityThanParent(index: currentIndex) {
                let parentIndex = parentIndex(childIndex: currentIndex)
                elements.swapAt(currentIndex, parentIndex)
                currentIndex = parentIndex
            }
        }
        
        
        private func hasHigherPriorityThanParent(index: Int) -> Bool {
            guard index < elements.endIndex else { return false }
            
            let parentIndex = parentIndex(childIndex: index)
            let parentElement = elements[parentIndex]
            let childElement = elements[index]
            
            return comparator(childElement, parentElement)
        }
        
        mutating func pop() -> Element? {
            guard !elements.isEmpty else { return nil }
            
            guard elements.count != 1 else { return elements.removeLast()}
            
            let lastIndex = elements.count - 1
            
            elements.swapAt(0, lastIndex)
            let result = elements.removeLast()
            
            siftDown(currentIndex: 0)
            
            return result
        }
        
        private mutating func siftDown(currentIndex: Int) {
            var swapIndex = currentIndex
            var isSwap = false
            let leftIndex = leftChildIndex(parentIndex: currentIndex)
            let rightIndex = rightChildIndex(parentIndex: currentIndex)
            
            if hasHigherPriorityThanParent(index: leftIndex) {
                swapIndex = leftIndex
                isSwap = true
            }
            
            if rightIndex < elements.endIndex && comparator(elements[rightIndex], elements[swapIndex]) {
                swapIndex = rightIndex
                isSwap = true
            }
            
            if isSwap {
                elements.swapAt(swapIndex, currentIndex)
                siftDown(currentIndex: swapIndex)
            }
        }
        
        static func minHeap() -> Self{
            self.init(comparator: <)
        }
        
        static func maxHeap() -> Self{
            self.init(comparator: >)
        }
        
        // MARK: Index 관련 함수들
        private func leftChildIndex(parentIndex: Int) -> Int {
            parentIndex * 2 + 1
        }
        
        private func rightChildIndex(parentIndex: Int) -> Int {
            parentIndex * 2 + 2
        }
        
        private func parentIndex(childIndex: Int) -> Int {
            (childIndex - 1) / 2
        }
    }

}
