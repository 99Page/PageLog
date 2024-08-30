////
////  main.swift
////  bronze.to.silver
////
////  Created by 노우영 on 8/30/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
///// 1부터 99까지는 모두 한수.
//let n = Int(readLine()!)!
//
//if n <= 99 {
//    print(n)
//} else {
//    printHanSuCount()
//}
//
//func printHanSuCount() {
//    var hanSuCount = 99
//    
//    for value in (100...n) {
//        if isHanSu(value: value) {
//            hanSuCount += 1
//        }
//    }
//    
//    print(hanSuCount)
//}
//
//func isHanSu(value: Int) -> Bool {
//    guard value >= 100 && value <= 1000 else {
//        assert(false)
//        return false
//    }
//    
//    var copyValue = value
//    var digitNum: [Int] = []
//    
//    while copyValue > 0 {
//        let remain = copyValue % 10
//        digitNum.append(remain)
//        copyValue /= 10
//    }
//    
//    let diff = digitNum[1] - digitNum[0]
//    
//    for i in (2..<digitNum.count) {
//        let currentDiff = digitNum[i] - digitNum[i-1]
//        
//        if currentDiff != diff {
//            return false
//        }
//    }
//    
//    return true
//}
//
//
