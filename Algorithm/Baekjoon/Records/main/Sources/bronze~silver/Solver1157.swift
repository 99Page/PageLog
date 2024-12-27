//
//  Solver1157.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/27/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver1157 {
    static func solve() {
        var appearanceCount: [Character: Int] = [:]
        let line = [Character](readLine()!)
        
        for char in line {
            let uppercased = Character(char.uppercased())
            
            let currentCount = appearanceCount[uppercased] ?? 0
            let newCount = currentCount + 1
            appearanceCount.updateValue(newCount, forKey: uppercased)
        }
        
        let sorted = appearanceCount.sorted {
            $0.value > $1.value
        }
        
        if sorted.count == 1 {
            print(sorted[0].key)
        } else {
            if sorted[0].value != sorted[1].value {
                print(sorted[0].key)
            } else {
                print("?")
            }
        }
    }
}
