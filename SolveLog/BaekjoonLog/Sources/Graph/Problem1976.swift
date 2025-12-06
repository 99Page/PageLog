//
//  Problem1976.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Problem1976 {
    var cityCount = 0
    var visitCount = 0
    var links: [[Int]] = []
    var path: [Int] = []
    
    mutating func solve() {
        read()
        runFloydWarshall()
        travel()
    }
    
    mutating func runFloydWarshall() {
        
        for i in 1...cityCount { links[i][i] = 1 }
        
        for k in 1...cityCount {
            for i in 1...cityCount {
                for j in 1...cityCount {
                    if links[i][k] == 1 && links[k][j] == 1 {
                        links[i][j] = 1
                    }
                }
            }
        }
    }
    
    func travel() {
        var current = 0
        var next = 1
        
        while next < path.count {
            let currentCity = path[current]
            let nextCity = path[next]
            
            if links[currentCity][nextCity] == 1 {
                current = next
                next += 1
            } else {
                print("NO")
                return
            }
            
        }
        
        print("YES")
    }
    
    mutating func read() {
        cityCount = Int(readLine()!)!
        visitCount = Int(readLine()!)!
        
        links.append([])
        (0..<cityCount).forEach { _ in
            let link: [Int] = readArray()
            links.append([0] + link)
        }
        
        path = readArray()
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


