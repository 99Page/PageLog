//
//  Solver32172.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver32172 {
    var mem: [Int] = [0]
    var exist: Set<Int> = [0]

    let sequenceSize: Int

    
    init() {
        self.sequenceSize = Int(readLine()!)!
    }

    mutating func solve() {
        fillMem()
        
        print(mem[sequenceSize])
    }

    mutating func fillMem() {
        var index = 1
        
        while index <= sequenceSize {
            var value = mem[index - 1] - index
            
            if value < 0 || exist.contains(value) {
                value = mem[index - 1] + index
            }
            
            mem.append(value)
            
            exist.insert(value)
            index += 1
        }
    }



}
