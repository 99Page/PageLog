//
//  FloydWarshallSolver.swift
//  PageCollection
//
//  Created by 노우영 on 9/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// FloydWarshallSolver 구조체는 플로이드-워셜 알고리즘을 사용하여 그래프의 모든 정점 쌍 사이의 최단 경로를 계산합니다.
///
/// 플로이드-워셜 알고리즘은 다음과 같은 상황에서 주로 사용됩니다:
/// - **모든 정점 쌍 사이의 최단 경로를 계산**: 알고리즘은 그래프의 모든 정점 쌍 사이의 최단 경로를 계산합니다.
/// - **음의 가중치를 가진 간선이 있는 경우**: 플로이드-워셜 알고리즘은 음의 가중치가 있는 간선을 처리할 수 있습니다.
/// - **음수 사이클을 탐지**: 알고리즘은 음수 사이클의 존재를 탐지할 수 있습니다.
struct FloydWarshallSolver {
    private let arrayIndexBase: ArrayIndexBase
    private var distance: [[Int]]
    var executeResult: ExecuteResult = .notExecuted
    
    init(edges: [Edge], arrayIndexBase: ArrayIndexBase) {
        self.arrayIndexBase = arrayIndexBase
        let arraySize = arrayIndexBase.arraySize
        self.distance = Array(
            repeating: Array(repeating: Int.max, count: arraySize),
            count: arraySize
        )
        
        for i in 0..<arraySize {
            distance[i][i] = 0
        }
        
        for edge in edges {
            distance[edge.start][edge.destination] = min(distance[edge.start][edge.destination], edge.cost)
        }
    }
    
    /// 플로이드-워셜 알고리즘을 사용하여 모든 정점 쌍 사이의 최단 경로를 계산하는 함수
    /// - Returns: 모든 정점 쌍 사이의 최단 경로 비용을 나타내는 2차원 배열
    mutating func solve() -> [[Int]] {
        let nodeCount = distance.count
        let startIndex = arrayIndexBase.startIndex
        
        for k in startIndex..<nodeCount {
            for i in startIndex..<nodeCount {
                for j in startIndex..<nodeCount {
                    if distance[i][k] != .max && distance[k][j] != .max {
                        distance[i][j] = min(distance[i][j], distance[i][k] + distance[k][j])
                    }
                }
            }
        }
        
        if checkNegativeCycle() {
            executeResult = .negativeCycleDetected
            return []
        }
        
        executeResult = .success
        return distance
    }
    
    /// 음수 사이클이 있는지 확인하는 함수
    /// - Returns: 음수 사이클이 존재하면 true를 반환, 그렇지 않으면 false를 반환
    private func checkNegativeCycle() -> Bool {
        for i in 0..<distance.count {
            if distance[i][i] < 0 {
                return true
            }
        }
        return false
    }
    
    
    enum ExecuteResult {
        case success // 최종 계산된 비용을 포함
        case negativeCycleDetected // 음수 사이클이 발견된 경우
        case notExecuted // 실행되지 않은 이유를 포함
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
        
        var startIndex: Int {
            switch self {
            case .zero:
                return 0
            case .one:
                return 1
            }
        }
    }
    
    struct Edge {
        let start: Int
        let destination: Int
        let cost: Int
    }
}
