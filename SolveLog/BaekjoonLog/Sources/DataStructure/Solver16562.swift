//
//  Solver16562.swift
//  baekjoon-solve
//
//  Created by 노우영 on 9/4/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver16562 {
    
    let studentCount: Int
    let friendRelationCount: Int
    let money: Int
    
    let friends: [Friend]
    
    init() {
        let input: [Int] = readArray()
        self.studentCount = input[0]
        self.friendRelationCount = input[1]
        self.money = input[2]
        
        var id = 1 // id 0은 이준석
        
        let friendCosts: [Int] = readArray()
        var friends: [Friend] = []
        
        for friendCost in friendCosts {
            friends.append(Friend(id: id, cost: friendCost))
            id += 1
        }
        
        self.friends = friends
    }
    
    mutating func solve() {
        var unionFind = UnionFindSolver(arrayIndexBase: .zero(nodeCount: studentCount +  1)) // 친구의 수 + 자기자신
        
        (0..<friendRelationCount).forEach { _ in
            let relation: [Int] = readArray()
            unionFind.union(relation[0], relation[1])
        }
        
        var heap = Heap<Friend> { $0.cost < $1.cost }
        var cost = 0
        
        for friend in friends {
            heap.insert(friend)
        }
        
        while !heap.isEmpty {
            let current = heap.pop()!
            
            if !unionFind.isConnected(0, current.id) {
                unionFind.union(0, current.id)
                cost += current.cost
            }
        }
        
        print(cost <= money ? cost : "Oh no")
    }
    
    struct Friend: Comparable {
        static func < (lhs: Solver16562.Friend, rhs: Solver16562.Friend) -> Bool {
            lhs.cost < rhs.cost
        }
        
        let id: Int
        let cost: Int
    }
    
    struct UnionFindSolver {
        private var parent: [Int]
        private var rank: [Int]
        private let arrayIndexBase: ArrayIndexBase
        
        /// 유니온 파인드 초기화
        /// - Parameters:
        ///   - size: 초기 집합의 크기 (노드의 개수)
        ///   - arrayIndexBase: 배열 인덱스 기준 (0부터 또는 1부터 시작)
        init(arrayIndexBase: ArrayIndexBase) {
            self.arrayIndexBase = arrayIndexBase
            let arraySize = arrayIndexBase.arraySize
            self.parent = Array(0..<arraySize) // 각 노드는 자신을 부모로 설정
            self.rank = Array(repeating: 0, count: arraySize) // 모든 노드의 랭크는 0으로 초기화
        }
        
        /// 주어진 노드가 속한 집합의 루트를 찾습니다 (경로 압축 기법 사용).
        /// - Parameter node: 찾고자 하는 노드
        /// - Returns: 해당 노드가 속한 집합의 루트
        mutating func find(_ node: Int) -> Int {
            if parent[node] != node {
                parent[node] = find(parent[node])
            }
            
            return parent[node]
        }
        
        /// 두 노드를 동일한 집합으로 병합합니다 (유니온).
        /// - Parameters:
        ///   - node1: 첫 번째 노드
        ///   - node2: 두 번째 노드
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
        
        /// 두 노드가 같은 집합에 속해 있는지 확인합니다.
        /// - Parameters:
        ///   - node1: 첫 번째 노드
        ///   - node2: 두 번째 노드
        /// - Returns: 두 노드가 같은 집합에 속해 있으면 true, 그렇지 않으면 false
        mutating func isConnected(_ node1: Int, _ node2: Int) -> Bool {
            return find(node1) == find(node2)
        }
        
        /// 배열 인덱스 기준을 지정하는 열거형
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
            
            var addtinalIndex: Int {
                switch self {
                case .zero:
                    return 0
                case .one:
                    return 1
                }
            }
        }
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

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

