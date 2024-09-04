//
//  UnionFindSolver.swift
//  PageCollection
//
//  Created by 노우영 on 9/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// UnionFind 구조체는 서로소 집합(Disjoint Set)을 구현한 자료구조로,
/// 빠르게 집합을 병합하거나(Union) 두 요소가 같은 집합에 속하는지 확인(Find)할 수 있습니다.
/// 인덱스 기반 처리를 위해 ArrayIndexBase를 지원합니다.
struct UnionFind {
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
