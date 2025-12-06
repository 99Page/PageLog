//
//  Solver1507.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/22/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// 새로운 유형의 문제였다.
/// 문제에서 말하는 -1이 나오는 경우가 잘 이해가 안됐는데
/// 주어진 입력 값이 최소가 아닌 경우를 뜻했다.
///
/// 즉, 1->3이 3으로 주어졌는데
/// 1->2, 2->3 이 각각 1이면 1->3의 최소값은 2여야한다.
/// 이런 경우가 -1 
struct Solver1507 {
    
    let cityCount: Int
    let rails: [[Int]]
    
    var minRails: [[Int]]
    var isVisited: [[Bool]]
    var result = 0
    
    init() {
        let cityCount = Int(readLine()!)!
        self.cityCount = cityCount
        self.rails = readGrid(cityCount)
        
        self.minRails = Array(repeating: Array(repeating: 0, count: cityCount), count: cityCount)
        self.isVisited = Array(repeating: Array(repeating: false, count: cityCount), count: cityCount)
    }
    
    mutating func solve() {
        for i in 0..<cityCount {
            for j in i+1..<cityCount {
                findSum(row: i, col: j)
            }
        }
        
        if result != -1 {
            
            for i in 0..<cityCount {
                for j in i+1..<cityCount {
                    result += minRails[i][j]
                }
            }
            
        }
        
        print(result)
    }
    
    /// 특정 행(row)과 열(col)에 대해 경로 합계를 찾고, 상삼각 행렬에 값을 채운다.
    private mutating func findSum(row: Int, col: Int) {
        /// 주어진 위치에 rails 값을 minRails에 초기화
        minRails[row][col] = rails[row][col]

        for middle in 0..<cityCount {
            if middle != row && middle != col {
                let linkedCost = rails[row][middle] + rails[middle][col]
                
                /// 중간 경로 비용이 기존 경로 비용과 동일할 경우
                if linkedCost == rails[row][col] {
                    minRails[row][col] = 0
                    
                    /// row -> middle 경로를 방문하지 않았을 경우 상삼각 행렬 업데이트
                    if !isVisited[row][middle] {
                        fillUpperTriangularMatrix(row: row, col: middle, value: rails[row][middle])
                    }
                    
                    /// middle -> col 경로를 방문하지 않았을 경우 상삼각 행렬 업데이트
                    if !isVisited[middle][col] {
                        fillUpperTriangularMatrix(row: middle, col: col, value: rails[middle][col])
                    }
                }
                else if linkedCost < rails[row][col] {
                    result = -1
                    return
                }
            }
        }
        
        /// 현재 경로를 방문한 것으로 표시
        isVisited[row][col] = true
        isVisited[col][row] = true
    }
    
    /// 상삼각 행렬에 값을 채운다.
    /// 주어진 row와 col의 값을 상삼각 행렬의 적절한 위치에 value로 설정한다.
    private mutating func fillUpperTriangularMatrix(row: Int, col: Int, value: Int) {
        /// 행렬의 적절한 위치를 설정 (row는 최소값, col은 최대값)
        let minRow = min(row, col)
        let maxCol = max(row, col)
        
        /// 상삼각 행렬에 값을 설정
        minRails[minRow][maxCol] = value
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
