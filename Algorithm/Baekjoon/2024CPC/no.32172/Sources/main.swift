//
//  main.swift
//  2024.CPC
//
//  Created by 노우영 on 9/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

var mem: [Int] = [0]
var exist: Set<Int> = [0]

let sequenceSize = Int(readLine()!)!

solve()

func solve() {
    fillMem()
    
    print(mem[sequenceSize])
}

func fillMem() {
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


