//
//  TopologySorter.swift
//  PageKit
//
//  Created by 노우영 on 5/23/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct TopologicalSorter {
    let nodeCount: Int
    private(set) var graph: [[Int]]
    private(set) var indegree: [Int]

    init(nodeCount: Int) {
        self.nodeCount = nodeCount
        self.graph = Array(repeating: [], count: nodeCount + 1)
        self.indegree = Array(repeating: 0, count: nodeCount + 1)
    }

    mutating func addEdge(from u: Int, to v: Int) {
        graph[u].append(v)
        indegree[v] += 1
    }

    /// 위상 정렬 결과
    /// - Returns: 단 하나의 정렬 결과: [Int]
    ///            여러 정렬 가능성: nil
    ///            사이클 존재 시: 빈 배열
    mutating func sort() -> [Int] {
        var queue = Queue<Int>()
        
        for i in 1...nodeCount {
            if indegree[i] == 0 {
                queue.enqueue(i)
            }
        }

        var result = [Int]()

        while let current = queue.dequeue() {
            result.append(current)

            for next in graph[current] {
                indegree[next] -= 1
                if indegree[next] == 0 {
                    queue.enqueue(next)
                }
            }
        }

        return result.count == nodeCount ? result : []
    }
}
