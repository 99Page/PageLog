//
//  Solver14889.swift
//  baekjoon-solve
//
//  Created by 노우영 on 11/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver14889 {
    
    let peopleCount: Int
    let synergy: [[Int]]
    var peopleNumber: [Int]
    var combinations: [[Int]] = []
    
    init() {
        self.peopleCount = Int(readLine()!)!
        
        var synergy: [[Int]] = []
        
        for _ in 0..<peopleCount {
            let synergyRow: [Int] = readArray()
            synergy.append(synergyRow)
        }
        
        self.synergy = synergy
        self.peopleNumber = [Int](0..<peopleCount)
    }
    
    mutating func solve() {
        
        self.combinations = peopleNumber.makeCombinations(of: peopleCount / 2)
        
        var minDiff: Int = .max
        
        for index in 0..<combinations.count / 2 {
            let startTeam = combinations[index]
            let linkTeam = combinations[combinations.count - index - 1]
            
            let startTeamSynergy = countSynergy(of: startTeam)
            let linkTeamSynergy = countSynergy(of: linkTeam)
            let diff = abs(startTeamSynergy - linkTeamSynergy)
            
            minDiff = min(minDiff, diff)
        }
        
        print(minDiff)
    }
    
    func countSynergy(of combinations: [Int]) -> Int {
        var result = 0
        
        for i in combinations.indices {
            for j in i+1..<combinations.count {
                let p1 = combinations[i]
                let p2 = combinations[j]
                
                result += synergy[p1][p2]
                result += synergy[p2][p1]
            }
        }
        
        return result
    }
}

private extension Array {
    func makeCombinations(of k: Int) -> [[Element]] {
        guard k > 0 else { return [[]] }
        guard let first = self.first else { return [] }
        
        let subarray = Array(self[1..<self.count])
        
        let withFirst = subarray.makeCombinations(of: k - 1).map { $0 + [first] }
        let withoutFirst = subarray.makeCombinations(of: k)
        
        return withFirst + withoutFirst
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

