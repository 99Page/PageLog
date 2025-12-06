//
//  Solver1949.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// 우수 마을의 주민수 최대로
/// 우수 마을은 인접할 수 없다
/// 비우수 마을은 우수 마을과 인접해야한다
///
/// 항상 1번 노드를 루트로 설정.
/// mem + 재귀 활용해서 중복줄이고 모든 케이스 확인하기.
///
/// O는 우수 마을, X는 비우수 마을일 때 나올 수 있는 패턴은
/// O-X-O
/// O-X-X-O
/// X-O-X인데
/// 더 줄이면 X-O, O-X로 살펴볼 수 있다.
/// 여기서 X의 child가 없는 경우는 O-X-X가 나오기 이 경우만 처리해주면 될거같다.
struct Solver1949 {
    let villageCount: Int
    let populations: [Int]
    
    /// 각 배열의 0번 Int: 이 마을이 우수 마을일 때, 하위 트리를 포함한 최대 인구 수
    /// 각 배열의 1번 Int: 이 마을이 비우수 마을일 때, 하위 트리를 포함한 최대 인구 수
    var mem: [[Int]]
    var isVisited: [Bool]
    
    var childs: [Set<Int>] = []
    
    init() {
        self.villageCount = Int(readLine()!)!
        var populations: [Int] = [0]
        populations.append(contentsOf: readArray())
        self.populations = populations
        self.mem = Array(repeating: Array(repeating: -1, count: 2), count: villageCount + 1)
        self.isVisited = Array(repeating: false, count: villageCount + 1)
    }
    
    mutating func solve() {
        readEdges()
        var isVisitedForEdge = Array(repeating: false, count: villageCount + 1)
        isVisitedForEdge[1] = true
        removeParentEdge(node: 1, isVisited: &isVisitedForEdge)
        
        /// 1번 노드가 루트.
        isVisited[1] = true
        fillMem(node: 1, memIndex: 0)

        isVisited = Array(repeating: false, count: villageCount + 1)
        isVisited[1] = true
        
        fillMem(node: 1, memIndex: 1)
        
        print(max(mem[1][0], mem[1][1]))
    }
    
    private mutating func readEdges() {
        childs = Array(repeating: [], count: villageCount + 1)
        
        (0..<villageCount - 1).forEach { _ in
            let input: [Int] = readArray()
            let node1 = input[0]
            let node2 = input[1]
            
            childs[node1].insert(node2)
            childs[node2].insert(node1)
        }
    }
    
    private mutating func removeParentEdge(node: Int, isVisited: inout [Bool]) {
        for child in childs[node] {
            if isVisited[child] {
                childs[node].remove(child)
            } else {
                isVisited[child] = true
                removeParentEdge(node: child, isVisited: &isVisited)
            }
        }
    }
    
    @discardableResult
    private mutating func fillMem(node: Int, memIndex: Int) -> Int {
        guard mem[node][memIndex] == -1 else { return mem[node][memIndex] }
        
        guard childs[node].count != 0 else {
            if memIndex == 0 {
                mem[node][memIndex] = populations[node]
            } else {
                mem[node][memIndex] = 0
            }
            
            return mem[node][memIndex]
        }
        
        
        if mem[node][memIndex] == -1 {
            if memIndex == 0 {
                mem[node][memIndex] = populations[node]
            } else {
                mem[node][memIndex] = 0
            }
        }
        
        for child in childs[node] {
            if !isVisited[child] {
                if memIndex == 0 {
                    isVisited[child] = true
                    let childMem = fillMem(node: child, memIndex: 1)
                    mem[node][memIndex] += childMem
                    isVisited[child] = false
                } else {
                    isVisited[child] = true
                    var childMemMax: Int = 0
                    let childMem = fillMem(node: child, memIndex: 0)
                    childMemMax = childMem
                    
                    if childs[child].count > 0 {
                        let childMem = fillMem(node: child, memIndex: 1)
                        childMemMax = max(childMemMax, childMem)
                    }
                    
                    isVisited[child] = false
                    mem[node][memIndex] += childMemMax
                }
            }
        }
        
        return mem[node][memIndex]
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

