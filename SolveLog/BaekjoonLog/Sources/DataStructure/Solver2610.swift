//
//  Solver2610.swift
//  baekjoon-solve
//
//  Created by 노우영 on 9/4/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

//7
//6
//1 2
//1 4
//1 3
//1 5
//5 6
//6 7

// 1차: 한개 그래프에서 최대 거리 구하기
// 2차: 노드 그루핑하기
// 3차: 그룹된 것들에서 최소 거리를 갖는 노드 구하기

// 1차에서 사용할수 있는 로직은 BFS or Floyd warshall이 최선. 
struct Solver2610 {
    
    let peopleCount: Int
    let relationCount: Int
    let relationsInput: [[Int]]
    
    var relations: [[Int]]
    var maxDistances: [Int]
    
    init() {
        self.peopleCount = Int(readLine()!)!
        self.relationCount = Int(readLine()!)!
        
        var relations: [[Int]] = []
        
        (0..<relationCount).forEach { _ in
            let relation: [Int] = readArray()
            relations.append(relation)
        }
        
        self.relationsInput = relations
        self.relations = Array(repeating: [], count: peopleCount + 1)
        self.maxDistances = Array(repeating: .max, count: peopleCount + 1)
    }
    
    mutating func solve() {
        var rank: [Int] = Array(repeating: 0, count: peopleCount + 1)
        var unionFinder = UnionFindSolver(arrayIndexBase: .one(nodeCount: peopleCount))
        
        for relation in relationsInput {
            rank[relation[0]] += 1
            rank[relation[1]] += 1
            
            relations[relation[0]].append(relation[1])
            relations[relation[1]].append(relation[0])
        }
        
        (1...peopleCount).forEach { num in
            findMaxDistance(num)
        }
        
        for relation in relationsInput {
            unionFinder.union(relation[0], relation[1])
        }
        
        var minDistByGroup: [Int: Int] = [:]
        var leaderByGroup: [Int: Int] = [:]
        
        (1...peopleCount).forEach { num in
            let group = unionFinder.find(num)
            let dist = maxDistances[num]
            let minDist = minDistByGroup[group] ?? .max
            
            if dist < minDist {
                leaderByGroup[group] = num
                minDistByGroup[group] = dist
            }
        }
        
        print(leaderByGroup.values.count)
        print(leaderByGroup.values.sorted().map { String($0) }.joined(separator: "\n"))
    }
    
    mutating func findMaxDistance(_ node: Int) {
        var isVisited = Array(repeating: false, count: peopleCount + 1)
        var dist = Array(repeating: 0, count: peopleCount + 1)
        var maxDist = 0
        
        var queue = Queue<Int>()
        queue.enqueue(node)
        isVisited[node] = true
        
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            
            for next in relations[current] {
                if !isVisited[next] {
                    dist[next] = dist[current] + 1
                    isVisited[next] = true
                    maxDist = max(maxDist, dist[next])
                    queue.enqueue(next)
                }
            }
        }
        
        maxDistances[node] = maxDist
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

}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

