////
////  main.swift
////  bronze.to.silver.solve
////
////  Created by 노우영 on 9/3/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
//let conditions: [Int] = readArray()
//let circleCount = conditions[0]
//let numberPerCircleCount = conditions[1]
//let rotateCount = conditions[2]
//
//var numberGrid: [[Int]] = []
//var startIndexes = Array(repeating: 0, count: circleCount + 1)
//var rotates: [Rotate] = []
//
//readNumbers()
//readRotate()
//solve()
//
//func solve() {
//    for rotate in rotates {
//        rotateCircle(rotate: rotate)
//    }
//}
//
//func removeNearNumbers(k: Int) {
//    var target = k
//    
//    while target <= k {
//        removeInCircle(k: k)
//        
//        target += k
//    }
//}
//
//func removeWithCircle(k: Int) {
//    let startIndex = startIndexes[k]
//    
//}
//
//func removeInCircle(k: Int) {
//    let numbers = numberGrid[k]
//    
//    var lastNumber = 0
//    var lastIndex = 0
//    
//    for (index, number) in numbers.enumerated() {
//        if number == 0 {
//            continue
//        }
//        
//        if lastNumber == number {
//            numberGrid[k][index] = 0
//            numberGrid[k][lastIndex] = 0
//        }
//        
//        lastNumber = number
//        lastIndex = index
//    }
//    
//    if numberGrid[k][0] == numberGrid[k][numberPerCircleCount - 1] {
//        numberGrid[k][0] = 0
//        numberGrid[k][numberPerCircleCount - 1] = 0
//    }
//}
//
//func readRotate() {
//    (0..<rotateCount).forEach { _ in
//        let input: [Int] = readArray()
//        let rotate = Rotate(input: input)
//        rotates.append(rotate)
//    }
//}
//
//func readNumbers() {
//    numberGrid.append([])
//    
//    (0..<numberPerCircleCount).forEach { _ in
//        let numberArray: [Int] = readArray()
//        numberGrid.append(numberArray)
//    }
//}
//
//func rotateCircle(rotate: Rotate) {
//    var target = rotate.k
//    
//    while target <= circleCount {
//        let startIndexOfTarget = startIndexes[target]
//        
//        switch rotate.direction {
//        case .clockWise:
//            let newIndex = (startIndexOfTarget + rotate.t) % numberPerCircleCount
//            startIndexes[target] = newIndex
//        case .counterclockWise:
//            let newIndex = (startIndexOfTarget - rotate.t) % numberPerCircleCount
//            startIndexes[target] = newIndex
//        }
//        
//        target += rotate.k
//    }
//}
//
//func readArray<T: LosslessStringConvertible>() -> [T] {
//    let line = readLine()!
//    let splitedLine = line.split(separator: " ")
//    let array = splitedLine.map { T(String($0))! }
//    return array
//}
//
//struct Rotate {
//    let k: Int
//    let direction: Direction
//    let t: Int
//    
//    init(input: [Int]) {
//        self.k = input[0]
//        self.direction = input[1] == 1 ? .clockWise : .counterclockWise
//        self.t = input[2]
//    }
//    
//    enum Direction {
//        case clockWise
//        case counterclockWise
//    }
//}
//
