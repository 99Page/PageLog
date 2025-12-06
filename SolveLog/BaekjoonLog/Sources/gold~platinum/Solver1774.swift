//
//  Solver1774.swift
//  baekjoon-solve
//
//  Created by 노우영 on 7/28/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

// 문제에서 '연결' 이라는 관계가 나와있다.
// -> 쉽게 그래프를 떠올릴 수 있는 문제.
// 모든 노드를 이어야하는, MST 문제로 판단.

// Edge를 만드는 작업 필요.
struct Solver1774 {
    
    var edges: [Edge] = []
    var nodeCount = 0
    var rinkedRelations: [[Int]] = []
    
    let coordinates: [Coordinate]
    
    var parent: [Int] = []
    var rank: [Int] = []
    
    
    init() {
        let metaInput: [Int] = readArray()
        
        self.nodeCount = metaInput[0]
        let linkCount = metaInput[1]
               
        var coordinates: [Coordinate] = []
        
        (0..<nodeCount).forEach { _ in
            let coordinateInput: [Int] = readArray()
            let coordinate = Coordinate(x: coordinateInput[0], y: coordinateInput[1] )
            coordinates.append(coordinate)
        }
        
        self.coordinates = coordinates
        
        (0..<linkCount).forEach { _ in
            let linkInput: [Int] = readArray()
            self.rinkedRelations.append(linkInput)
        }
        
        for i in 0..<nodeCount {
            parent.append(i)
            rank.append(0)
        }
    }
    
    mutating func solve() {
        makeEdges()
        unionGivenNodes()
        let weightSum = unionNodes()
        print(String(format: "%.2f", weightSum))
        
    }
    
    mutating func unionNodes() -> Double {
        var weightSum: Double = 0
        
        for edge in edges {
            if !isConnected(node1: edge.source, node2: edge.destination) {
                union(node1: edge.source, node2: edge.destination)
                weightSum += edge.weight
            }
        }
        
        return weightSum
    }
    
    mutating func unionGivenNodes() {
        for rinkedRelation in rinkedRelations {
            let node1 = rinkedRelation[0] - 1
            let node2 = rinkedRelation[1] - 1
            
            union(node1: node1, node2: node2)
        }
    }
    
    mutating func makeEdges() {
        for i in 0..<coordinates.count {
            for j in i+1..<coordinates.count {
                let coordinate1 = coordinates[i]
                let coordinate2 = coordinates[j]
                let weight = sqrt(pow(Double(coordinate1.x) - Double(coordinate2.x), 2) + pow(Double(coordinate1.y) - Double(coordinate2.y), 2))
                let edge = Edge(source: i, destination: j, weight: weight)
                edges.append(edge)
            }
        }
        
        edges.sort { $0.weight < $1.weight }
    }
    
    mutating func find(_ node: Int) -> Int {
        // 자기 자신을 만날 때 까지 반복
        if parent[node] != node {
            parent[node] = find(parent[node])
        }
        
        return parent[node]
    }
    
    mutating func isConnected(node1: Int, node2: Int) -> Bool {
        find(node1) == find(node2)
    }
    
    mutating func union(node1: Int, node2: Int) {
        let parent1 = find(node1)
        let parent2 = find(node2)
        
        guard parent1 != parent2 else { return }
        
        if rank[parent1] > rank[parent2] {
            parent[parent2] = parent1
        } else if rank[parent1] < rank[parent2] {
            parent[parent1] = parent2
        } else {
            parent[parent2] = parent1
            rank[parent1] += 1
        }
    }
    
    
    struct Coordinate {
        let x: Int
        let y: Int
    }
    
    
    struct Edge {
        let source: Int
        let destination: Int
        let weight: Double
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

