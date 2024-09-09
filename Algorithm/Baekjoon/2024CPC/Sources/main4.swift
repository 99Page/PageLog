////
////  main4.swift
////  2024.CPC
////
////  Created by 노우영 on 9/9/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
//let input: [Int] = readArray()
//let cardCount = input[0]
//let shuffleCount = input[1]
//
//var jokerLocationMem: [Int] = [0]
//
//solve()
//
//func solve() {
//    (0..<shuffleCount).forEach { _ in
//        let shuffleInfo: [Int] = readArray()
//        shuffle(shuffleInfo)
//    }
//    
//    print(jokerLocationMem.last! + 1)
//}
//
//func shuffle(_ shuffleInfo: [Int]) {
//    switch shuffleInfo[0] {
//    case 1:
//        shuffleUp(shuffleInfo[1])
//    case 2:
//        shuffleDown(shuffleInfo[1])
//    case 3:
//        shuffleSet(to: shuffleInfo[1])
//    default:
//        break
//    }
//}
//
//func shuffleSet(to state: Int) {
//    let location = jokerLocationMem[state]
//    jokerLocationMem.append(location)
//}
//
//func shuffleDown(_ count: Int) {
//    var currentJokerLocation = jokerLocationMem.last!
//    
//    let modularCount = count % cardCount
//    
//    currentJokerLocation = (currentJokerLocation - modularCount)
//    currentJokerLocation = (currentJokerLocation + cardCount) % cardCount
//    
//    jokerLocationMem.append(currentJokerLocation)
//}
//
//func shuffleUp(_ count: Int) {
//    var currentJokerLocation = jokerLocationMem.last!
//    
//    let modularCount = count % cardCount
//    
//    currentJokerLocation = (currentJokerLocation + modularCount)
//    currentJokerLocation = currentJokerLocation % cardCount
//    
//    jokerLocationMem.append(currentJokerLocation)
//}
//
//
//func readArray<T: LosslessStringConvertible>() -> [T] {
//    let line = readLine()!
//    let splitedLine = line.split(separator: " ")
//    let array = splitedLine.map { T(String($0))! }
//    return array
//}
//
