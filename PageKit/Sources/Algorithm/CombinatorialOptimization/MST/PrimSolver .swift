//
//  PrimSolver .swift
//  PageCollection
//
//  Created by 노우영 on 10/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct PrimSolver {
    /// 주어진 간선 정보와 노드 수를 바탕으로 최소 신장 트리의 가중치 합을 구하는 함수
    /// - Parameters:
    ///   - edges: 정렬되지 않은 가중치가 있는 간선들의 배열.
    ///   - arrayIndexBase: UnionFind에서 사용하는 배열의 시작 인덱스 베이스
    ///   - nodeCount: 그래프의 노드 개수
    /// - Returns: 최소 신장 트리의 총 가중치
    static func findMinTotalWeight(edges: [[Edge]], arrayIndexBase: UnionFindSolver.ArrayIndexBase, nodeCount: Int) -> Int {
        var edgeQueue = Heap<Edge>.minHeap()
        var isLinked: [Bool] = Array(repeating: false, count: nodeCount + 1)
        var linkCount = 0
        var totalWeight = 0
        
        isLinked[1] = true
        insertEdgesOfNode(1, edges: edges, to: &edgeQueue)
        
        while linkCount < nodeCount - 1 {
            let edge = edgeQueue.pop()!
            
            if !isLinked[edge.destination] {
                insertEdgesOfNode(edge.destination, edges: edges, to: &edgeQueue)
                isLinked[edge.destination] = true
                linkCount += 1
                totalWeight += edge.weight
            }
            
            if !isLinked[edge.source]{
                insertEdgesOfNode(edge.source, edges: edges, to: &edgeQueue)
                isLinked[edge.source] = true
                linkCount += 1
                totalWeight += edge.weight
            }
        }
        
        return totalWeight
    }

    /// 주어진 노드에 있는 간선들을 연결합니다.
    /// - Parameters:
    ///   - node: 주어진 노드
    ///   - edgeQueue: 간선이 추가될 큐
    static private func insertEdgesOfNode(_ node: Int, edges: [[Edge]], to edgeQueue: inout Heap<Edge>) {
        for edge in edges[node] {
            edgeQueue.insert(edge)
        }
    }
    
    
    /// 간선 정보를 담은 구조체
    struct Edge: Comparable {
        static func < (lhs: Edge, rhs: Edge) -> Bool {
            lhs.weight < rhs.weight
        }
        
        let source: Int
        let destination: Int
        let weight: Int
    }
}
