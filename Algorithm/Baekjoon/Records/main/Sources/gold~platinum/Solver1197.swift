//
//  Solver1197.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// Prim 방식으로 풀이하면 time out.
struct Solver1197 {
    
    let nodeCount: Int
    let edgeCount: Int
    var edges: [Edge] = []
    
    init() {
        let firstLineInput: [Int] = readArray()
        self.nodeCount = firstLineInput[0]
        self.edgeCount = firstLineInput[1]
        
    }
    
    mutating func solve() {
        readEdges()
        makeMST()
    }
    
    /// 간선을 입력받습니다.
    private mutating func readEdges() {
        (0..<edgeCount).forEach { _ in
            let edgeInput: [Int] = readArray()
            let source = edgeInput[0]
            let destination = edgeInput[1]
            let weight = edgeInput[2]
            let edge = Edge(source: source, destination: destination, weight: weight)
            edges.append(edge)
        }
        
        edges.sort(by: <)
    }
    
    /// 크루스칼 알고리즘을 이용해 MST를 만들고, 최종 weight 합을 출력합니다.
    private mutating func makeMST() {
        var unionFinder = UnionFindSolver(arrayIndexBase: .one(nodeCount: nodeCount))
        var connectCount = 0
        var totalWeight = 0
        
        for edge in edges {
            if !unionFinder.isConnected(edge.source, edge.destination) {
                unionFinder.union(edge.source, edge.destination)
                connectCount += 1
                totalWeight += edge.weight
            }
            
            if connectCount == nodeCount - 1 {
                break
            }
        }
        
        print(totalWeight)
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

    
    
    struct Edge: Comparable {
        static func < (lhs: Solver1197.Edge, rhs: Solver1197.Edge) -> Bool {
            lhs.weight < rhs.weight
        }
        
        let source: Int
        let destination: Int
        let weight: Int
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
