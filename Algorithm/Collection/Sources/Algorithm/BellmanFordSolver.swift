//
//  BellmanFordSolver.swift
//  PageCollection
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// 벨만-포드 알고리즘을 사용하여 그래프의 최단 경로를 계산하는 구조체
///
/// 벨만-포드 알고리즘은 다음과 같은 상황에서 주로 사용됩니다:
/// - **음의 가중치를 가진 간선이 있는 그래프**: 다익스트라 알고리즘과 달리, 벨만-포드 알고리즘은 음의 가중치가 있는 간선을 처리할 수 있습니다.
/// - **음수 사이클(negative cycle) 탐지**: 그래프에 음수 사이클이 존재하는지 여부를 감지할 수 있습니다. 음수 사이클이 존재할 경우, 최단 경로는 무한히 줄어들 수 있기 때문에 이 문제를 해결하는 데 유용합니다.
/// - **한 정점에서 다른 정점까지의 최단 경로를 계산**: 벨만-포드 알고리즘은 단일 출발점에서 시작하여 모든 다른 정점까지의 최단 경로를 계산할 수 있습니다.
struct BellmanFordSolver {
    private let nodeCount: Int
    private let arrayIndexBase: ArrayIndexBase
    
    var edge: [Edge]
    var executeResult: ExecuteResult = .notExecuted
    
    init(nodeCount: Int, edge: [Edge], arrayIndexBase: ArrayIndexBase) {
        self.nodeCount = nodeCount
        self.arrayIndexBase = arrayIndexBase
        self.edge = edge
    }
    
    mutating func solve(startNode: Int) -> [Int] {
        let costSize = nodeCount + arrayIndexBase.rawValue
        var costs: [Int] = Array(repeating: .max, count: costSize)
        costs[startNode] = 0
        
        for _ in 0..<costs.count - 1 {
            var updated = false
            
            // 모든 간선을 확인하여 비용 갱신
            for edge in edge {
                if costs[edge.start] != .max && costs[edge.start] + edge.cost < costs[edge.destination] {
                    costs[edge.destination] = costs[edge.start] + edge.cost
                    updated = true
                }
            }
            
            // 만약 더 이상 갱신이 없다면 종료
            if !updated {
                break
            }
        }
        
        // 음수 사이클 확인
        for edge in edge {
            if costs[edge.start] != .max && costs[edge.start] + edge.cost < costs[edge.destination] {
                executeResult = .negativeCycleDetected
                return []
            }
        }
        
        // 성공적으로 종료된 경우
        executeResult = .success
        return costs
    }
    
    enum ExecuteResult {
        case success // 최종 계산된 비용을 포함
        case negativeCycleDetected // 음수 사이클이 발견된 경우
        case notExecuted // 실행되지 않은 이유를 포함
    }
    
    enum ArrayIndexBase: Int  {
        case zero = 0
        case one = 1
    }
    
    struct Edge {
        let start: Int
        let destination: Int
        let cost: Int
    }
}
