//
//  Solver1764.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1764 {
    let unseen: Set<String>
    let unheard: Set<String>
    
    init() {
        let count: [Int] = readArray()
        
        let unseenCount = count[0]
        let unheardCount = count[1]
        
        var unseen = Set<String>()
        var unheard = Set<String>()
        
        (0..<unseenCount).forEach { _ in
            let name = readLine()!
            unseen.insert(name)
        }
        
        (0..<unheardCount).forEach { _ in
            let name = readLine()!
            unheard.insert(name)
        }
        
        self.unseen = unseen
        self.unheard = unheard
    }
    
    mutating func solve() {
        let union = unseen.intersection(unheard)
        
        let orderedNames = union.sorted()
        
        print(orderedNames.count)
        
        for name in orderedNames {
            print(name)
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let array = line.split(separator: " ").map {
        T(String($0))!
    }
    return array
}
