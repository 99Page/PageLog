//
//  KruskalSolver.swift
//  PageCollection
//
//  Created by 노우영 on 10/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// Kruskal 알고리즘을 이용해 MST 가중치 합을 계산하는 구조체
struct KruskalSolver {

    /// 주어진 간선 정보와 노드 수를 바탕으로 최소 신장 트리의 가중치 합을 구하는 함수
    /// - Parameters:
    ///   - edges: 정렬되지 않은 가중치가 있는 간선들의 배열.
    ///   - arrayIndexBase: UnionFind에서 사용하는 배열의 시작 인덱스 베이스
    ///   - nodeCount: 그래프의 노드 개수
    /// - Returns: 최소 신장 트리의 총 가중치
    static func findMinTotalWeight(edges: [Edge], arrayIndexBase: UnionFindSolver.ArrayIndexBase, nodeCount: Int) -> Int {
        let sortedEdges = edges.sorted()

        var unionFinder = UnionFindSolver(arrayIndexBase: arrayIndexBase)
        var connectCount = 0
        var totalWeight = 0

        for edge in sortedEdges {
            /// 두 노드가 연결되지 않았다면 연결
            if !unionFinder.isConnected(edge.source, edge.destination) {
                unionFinder.union(edge.source, edge.destination)
                connectCount += 1
                totalWeight += edge.weight
            }

            /// 모든 노드가 연결되면 종료
            if connectCount == nodeCount - 1 {
                break
            }
        }

        return totalWeight
    }

    /// 간선 정보를 담은 구조체
    struct Edge: Comparable {
        static func < (lhs: KruskalSolver.Edge, rhs: KruskalSolver.Edge) -> Bool {
            lhs.weight < rhs.weight
        }
        
        let source: Int
        let destination: Int
        let weight: Int
    }
}
