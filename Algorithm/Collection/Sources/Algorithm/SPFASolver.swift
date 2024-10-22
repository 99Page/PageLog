//
//  SPFASolver.swift
//  PageCollection
//
//  Created by 노우영 on 10/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct SPFASolver {
    
    private let arrayIndexBase: NodeCount
    var edges: [[Edge]]
    
    init(edges: [[Edge]], arrayIndexBase: NodeCount) {
        self.arrayIndexBase = arrayIndexBase
        self.edges = edges
    }
    
    /// 시작 노드를 기준으로 SPFA 알고리즘을 사용하여 최단 거리를 계산합니다.
    /// - Parameter startNode: 시작 노드의 인덱스
    /// - Returns: 시작 노드로부터 각 노드까지의 최단 거리 배열
    mutating func solve(startNode: Int) -> [Int] {
        let costSize = arrayIndexBase.arraySize
        var costs: [Int] = Array(repeating: .max, count: costSize)
        var inQueue: [Bool] = Array(repeating: false, count: costSize)
        var queue = [Int]()
        
        costs[startNode] = 0
        queue.append(startNode)
        inQueue[startNode] = true
        
        while !queue.isEmpty {
            let currentNode = queue.removeFirst()
            inQueue[currentNode] = false
            
            for edge in edges[currentNode] {
                if costs[currentNode] != .max && costs[currentNode] + edge.cost < costs[edge.destination] {
                    costs[edge.destination] = costs[currentNode] + edge.cost
                    
                    if !inQueue[edge.destination] {
                        queue.append(edge.destination)
                        inQueue[edge.destination] = true
                    }
                }
            }
        }
        
        return costs
    }
    
    /// 노드의 인덱스가 0부터 시작하는지 또는 1부터 시작하는지 설정합니다.
    enum NodeCount {
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
    }
    
    /// 간선 정보를 저장하는 구조체로, 목적지와 비용을 포함합니다.
    struct Edge: Comparable {
        static func < (lhs: SPFASolver.Edge, rhs: SPFASolver.Edge) -> Bool {
            lhs.cost < rhs.cost
        }
        
        let destination: Int
        let cost: Int
    }
}
