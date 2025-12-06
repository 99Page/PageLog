//
//  Solver15681.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/6/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver15681 {
    let nodeCount: Int
    let rootNum: Int
    let queryCount: Int
    
    var edges: [[Int]] = []
    
    var subnodeCounts: [Int]
    var isVisited: [Bool]
    
    init() {
        let firstLineInput: [Int] = readArray()
        self.nodeCount = firstLineInput[0]
        self.rootNum  = firstLineInput[1]
        self.queryCount = firstLineInput[2]
        
        /// 1번부터 시작
        let arraySize = nodeCount + 1
        
        var edges: [[Int]] = Array(repeating: [], count: arraySize)
        
        for _ in 0..<nodeCount - 1 {
            let edge: [Int] = readArray()
            let node1 = edge[0]
            let node2 = edge[1]
            
            edges[node1].append(node2)
            edges[node2].append(node1)
        }
        
        self.edges = edges
        self.subnodeCounts = Array(repeating: 0, count: arraySize)
        self.isVisited = Array(repeating: false, count: arraySize)
    }
    
    mutating func solve() {
        isVisited[rootNum] = true
        let _ = countSubnodes(node: rootNum)
        var answers: [Int] = []
        
        for _ in 0..<queryCount {
            let query = Int(readLine()!)!
            let answer = subnodeCounts[query]
            answers.append(answer)
        }
        
        print(answers.joinedString(with: "\n"))
    }
    
    mutating func countSubnodes(node: Int) -> Int {
        
        var count = 1
        
        for node in edges[node] {
            if !isVisited[node] {
                isVisited[node] = true
                count += countSubnodes(node: node)
            }
        }
        
        subnodeCounts[node] = count
        return subnodeCounts[node]
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}
