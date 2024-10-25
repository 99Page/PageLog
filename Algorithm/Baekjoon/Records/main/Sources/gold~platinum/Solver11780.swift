//
//  Solver11780.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver11780 {
    let cityCount: Int
    let roadCount: Int
    
    var roads: [[Int]]
    var paths: [[[Int]]]
    
    
    init() {
        self.cityCount = Int(readLine()!)!
        self.roadCount = Int(readLine()!)!
        
        let roadInputs: [[Int]] = readGrid(roadCount)
        
        var roads: [[Int]] = Array(repeating: Array(repeating: .max, count: cityCount), count: cityCount)
        
        self.paths = Array(repeating: Array(repeating: [], count: cityCount), count: cityCount)
        
        for roadInput in roadInputs {
            let source = roadInput[0] - 1
            let destination = roadInput[1] - 1
            let weight = roadInput[2]
            
            roads[source][destination] = min(weight, roads[source][destination])
            paths[source][destination] = [source + 1, destination + 1]
        }
        
        self.roads = roads
    }
    
    mutating func solve() {
        for i in 0..<cityCount {
            roads[i][i] = 0
        }
        
        for k in 0..<cityCount {
            for i in 0..<cityCount {
                for j in 0..<cityCount {
                    if roads[i][k] != .max && roads[k][j] != .max && roads[i][j] > roads[i][k] + roads[k][j] {
                        roads[i][j] = roads[i][k] + roads[k][j]
                        appendPath(source: i, middle: k, destination: j)
                    }
                }
            }
        }
        
        for i in 0..<cityCount {
            for j in 0..<cityCount {
                if roads[i][j] == .max {
                    roads[i][j] = 0
                }
            }
        }
        
        print(roads.joinedString2D())
        
        for i in 0..<cityCount {
            for j in 0..<cityCount {
                if roads[i][j] == 0 {
                    print(0)
                } else {
                    let pathArray = paths[i][j]
                    let pathString = pathArray.joinedString()
                    let path = "\(pathArray.count) \(pathString)"
                    print(path)
                }
            }
        }
    }
    
    mutating func appendPath(source: Int, middle: Int, destination: Int) {
        var newPath: [Int] = paths[source][middle]
        newPath.removeLast()
        newPath.append(contentsOf: paths[middle][destination])
        
        paths[source][destination] = newPath
    }
    
    struct Edge {
        let source: Int
        let destination: Int
        let weight: Int
    }
}

private func readGrid<T: LosslessStringConvertible>(_ k: Int) -> [[T]] {
    var result: [[T]] = []
    
    (0..<k).forEach { _ in
        let array: [T] = readArray()
        result.append(array)
    }
    
    return result
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

private extension Array where Element: Collection, Element.Element: LosslessStringConvertible {
    /// 2차원 배열의 각 요소를 문자열로 변환한 후 각 행을 지정된 구분자로 결합하고, 행들은 `\n`으로 구분하여 반환합니다.
    /// - Parameter separator: 각 행 내의 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString2D(with separator: String = " ") -> String {
        self.map { row in
            row.map(String.init).joined(separator: separator)
        }.joined(separator: "\n")
    }
}

private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}
