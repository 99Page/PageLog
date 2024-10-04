//
//  Solver10830.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver10830 {
    let modular = 1_000
    let n: Int
    let b: Int
    
    var givenMatrix: [[Int]] = []
    var result: [[Int]] = []

    
    init() {
        let input = readNAndB()
        self.n = input.0
        self.b = input.1
    }
    
    mutating func solve() {
        readMatrix()
        result = calculateMatrix(power: b)
        printResult()
    }

    func printResult() {
        for rowElements in result {
            for element in rowElements {
                print("\(element)", terminator: " ")
            }
            print()
        }
    }

    func calculateMatrix(power: Int) -> [[Int]] {
        guard power >= 2 else { return givenMatrix }
        
        let isOdd = power % 2 == 1
        
        let matrix = calculateMatrix(power: power / 2)
        var multiplcatedMatrix = multiplyMatrix(lhs: matrix, rhs: matrix)
        
        if isOdd {
            multiplcatedMatrix = multiplyMatrix(lhs: multiplcatedMatrix, rhs: givenMatrix)
        }
        
        return multiplcatedMatrix
    }

    func multiplyMatrix(lhs: [[Int]], rhs: [[Int]]) -> [[Int]] {
        var multiplicatedMatrix: [[Int]] = []
        
        for row in 0..<n {
            var multipliactedRow: [Int] = []
            
            for col in 0..<n {
                let element = getMulticpliedElement(row: row, col: col, lhs: lhs, rhs: rhs)
                multipliactedRow.append(element)
            }
            
            multiplicatedMatrix.append(multipliactedRow)
        }
        
        return multiplicatedMatrix
    }

    func getMulticpliedElement(row: Int, col: Int, lhs: [[Int]], rhs: [[Int]]) -> Int {
        var result: Int = 0
        
        for k in 0..<n {
            result += lhs[row][k] * rhs[k][col]
        }
        
        return result % modular
    }


    mutating func readMatrix() {
        for _ in 0..<n {
            let input = readLine()!
            let splitedInput = input.split(separator: " ")
            /// 계산할 때만 하는게 아니라 입력할 때도 modular 적용 해줘야한다.
            let row = splitedInput.map { Int($0)! % modular}
            givenMatrix.append(row)
        }
    }
}


private func readNAndB() -> (Int, Int) {
    let input = readLine()!
    let splitedInput = input.split(separator: " ")
    let n = Int(splitedInput[0])!
    let b = Int(splitedInput[1])!
    return (n, b)
}
