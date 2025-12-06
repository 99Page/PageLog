//
//  Solver14719.swift
//  baekjoon-solve
//
//  Created by 노우영 on 7/24/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct Solver14719 {
    
    let colSize: Int
    let rowSize: Int
    let blockHeights: [Int]
    
    // 0은 빈 곳, 1은 기둥, 2는 물
    var map: [[Int]] = []
    var result = 0
    
    init() {
        let mapMeta: [Int] = readArray()
        self.colSize = mapMeta[1]
        self.rowSize = mapMeta[0]
        self.blockHeights = readArray()
    }
    
    mutating func solve() {
        makeMap()
        fillWaterFromBottom()
        print(result)
    }
    
    // 밑바닥부터 물채우기 시작
    private mutating func fillWaterFromBottom() {
        for row in (0..<rowSize).reversed() {
            fillWater(row: row)
        }
    }
    
    private mutating func fillWater(row: Int) {
        var flush = 0 // 블록 사이에 있는 물만 저장
        var meetBlock = false
        
        for col in (0..<colSize) {
            if map[row][col] == 1{
                if meetBlock {
                    result += flush
                    flush = 0
                } else {
                    meetBlock = true
                }
            }
            
            if meetBlock && map[row][col] == 0 {
                flush += 1
            }
        }
    }
    
    private mutating func makeMap() {
        self.map = Array(repeating: Array(repeating: 0, count: colSize), count: rowSize)
        
        for (col, height) in blockHeights.enumerated() {
            let diff = rowSize - height
            for row in (0..<height).reversed() {
                map[row+diff][col] = 1
            }
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

