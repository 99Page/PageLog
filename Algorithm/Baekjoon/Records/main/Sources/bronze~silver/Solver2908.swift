//
//  Solver2908.swift
//  bronze.to.silver.solve
//
//  Created by 노우영 on 9/30/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver2908 {
    
    func solve() {
        let input = readLine()!.split(separator: " ")

        let a = String(input[0].reversed())
        let b = String(input[1].reversed())
        let reversedValueOfA = Int(a)!
        let reversedValueOfB = Int(b)!

        if reversedValueOfA > reversedValueOfB {
            print(reversedValueOfA)
        } else {
            print(reversedValueOfB)
        }

    }
}
