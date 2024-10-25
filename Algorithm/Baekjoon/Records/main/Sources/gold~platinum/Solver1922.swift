//
//  Solver1922.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1922 {
    let nodeCount: Int
    let edgeCount: Int
    var edges: [[Edge]] = []
    
    init() {
        self.nodeCount = Int(readLine()!)!
        self.edgeCount = Int(readLine()!)!
        
    }
    
    mutating func solve() {
        readEdges()
        makeMST()
    }
    
    /// MST 트리를 만듭니다. 이후 최종 weight합을 출력합니다.
    mutating func makeMST() {
        var edgeQueue = Heap<Edge>.minHeap()
        var isLinked: [Bool] = Array(repeating: false, count: nodeCount + 1)
        var linkCount = 0
        var totalWeight = 0
        
        isLinked[1] = true
        insertEdgesOfNode(1, to: &edgeQueue)
        
        while linkCount < nodeCount - 1 {
            let edge = edgeQueue.pop()!
            
            if !isLinked[edge.destination] {
                insertEdgesOfNode(edge.destination, to: &edgeQueue)
                isLinked[edge.destination] = true
                linkCount += 1
                totalWeight += edge.weight
            }
            
            if !isLinked[edge.source]{
                insertEdgesOfNode(edge.source, to: &edgeQueue)
                isLinked[edge.source] = true
                linkCount += 1
                totalWeight += edge.weight
            }
        }
        
        print(totalWeight)
    }
    
    /// 주어진 노드에 있는 간선들을 연결합니다.
    /// - Parameters:
    ///   - node: 주어진 노드
    ///   - edgeQueue: 간선이 추가될 큐
    private mutating func insertEdgesOfNode(_ node: Int,  to edgeQueue: inout Heap<Edge>) {
        for edge in edges[node] {
            edgeQueue.insert(edge)
        }
    }
    
    /// 간선을 입력받습니다.
    private mutating func readEdges() {
        self.edges = Array(repeating: [], count: nodeCount + 1)
        
        (0..<edgeCount).forEach { _ in
            let edgeInput: [Int] = readArray()
            let source = edgeInput[0]
            let destination = edgeInput[1]
            let weight = edgeInput[2]
            let edge = Edge(source: source, destination: destination, weight: weight)
            edges[source].append(edge)
            edges[destination].append(edge)
        }
    }
    
    
    struct Edge: Comparable {
        static func < (lhs: Edge, rhs: Edge) -> Bool {
            lhs.weight < rhs.weight
        }
        
        let source: Int
        let destination: Int
        let weight: Int
    }
    
    struct Heap<Element: Comparable> {
        private let comparator: (Element, Element) -> Bool
        private(set) var storage: [Element] = []
        
        init(comparator: @escaping (Element, Element) -> Bool) {
            self.comparator = comparator
        }
        
        var isEmpty: Bool {
            storage.isEmpty
        }
        
        func peek() -> Element? {
            storage.first
        }
        
        /// - Complexity: O(log n)
        mutating func insert(_ element: Element) {
            storage.append(element)
            let insertedIndex = storage.count - 1
            siftUp(startIndex: insertedIndex)
        }
        
        mutating private func siftUp(startIndex: Int) {
            var currentIndex = startIndex
            
            while hasHigherPriorityThanParent(index: currentIndex) {
                let parentIndex = parentIndex(childIndex: currentIndex)
                storage.swapAt(currentIndex, parentIndex)
                currentIndex = parentIndex
            }
        }
        
        
        private func hasHigherPriorityThanParent(index: Int) -> Bool {
            guard index < storage.endIndex else { return false }
            
            let parentIndex = parentIndex(childIndex: index)
            let parentElement = storage[parentIndex]
            let childElement = storage[index]
            
            return comparator(childElement, parentElement)
        }
        
        mutating func pop() -> Element? {
            guard !storage.isEmpty else { return nil }
            
            guard storage.count != 1 else { return storage.removeLast()}
            
            let lastIndex = storage.count - 1
            
            storage.swapAt(0, lastIndex)
            let result = storage.removeLast()
            
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
            
            if rightIndex < storage.endIndex && comparator(storage[rightIndex], storage[swapIndex]) {
                swapIndex = rightIndex
                isSwap = true
            }
            
            if isSwap {
                storage.swapAt(swapIndex, currentIndex)
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

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

