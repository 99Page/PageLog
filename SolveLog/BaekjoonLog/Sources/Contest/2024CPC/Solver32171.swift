//
//  Solver32171.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver32171 {
    
    var minX: Int = .max
    var maxX: Int = .min
    var minY: Int = .max
    var maxY: Int = .min
    
    mutating func solve() {
        let buildingCount = Int(readLine()!)!
        
        (0..<buildingCount).forEach { _ in
            let buildingSize: [Int] = readArray()
            minX = min(minX, buildingSize[0])
            minY = min(minY, buildingSize[1])
            maxX = max(maxX, buildingSize[2])
            maxY = max(maxY, buildingSize[3])
            
            printFenceSize()
        }
    }

    func printFenceSize() {
        let width = (maxX - minX) * 2
        let height = (maxY - minY) * 2
        print(width + height)
    }

    func readArray<T: LosslessStringConvertible>() -> [T] {
        let line = readLine()!
        let splitedLine = line.split(separator: " ")
        let array = splitedLine.map { T(String($0))! }
        return array
    }


}
