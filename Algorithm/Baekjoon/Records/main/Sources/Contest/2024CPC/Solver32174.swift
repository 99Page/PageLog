//
//  Solver32174.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver32174 {
    let cardCount: Int
    let shuffleCount: Int

    var jokerLocationMem: [Int] = [0]
    
    init() {
        let input: [Int] = readArray()
        self.cardCount = input[0]
        self.shuffleCount = input[1]
    }

    mutating func solve() {
        (0..<shuffleCount).forEach { _ in
            let shuffleInfo: [Int] = readArray()
            shuffle(shuffleInfo)
        }
        
        print(jokerLocationMem.last! + 1)
    }

    mutating func shuffle(_ shuffleInfo: [Int]) {
        switch shuffleInfo[0] {
        case 1:
            shuffleUp(shuffleInfo[1])
        case 2:
            shuffleDown(shuffleInfo[1])
        case 3:
            shuffleSet(to: shuffleInfo[1])
        default:
            break
        }
    }

    mutating func shuffleSet(to state: Int) {
        let location = jokerLocationMem[state]
        jokerLocationMem.append(location)
    }

    mutating func shuffleDown(_ count: Int) {
        var currentJokerLocation = jokerLocationMem.last!
        
        let modularCount = count % cardCount
        
        currentJokerLocation = (currentJokerLocation - modularCount)
        currentJokerLocation = (currentJokerLocation + cardCount) % cardCount
        
        jokerLocationMem.append(currentJokerLocation)
    }

    mutating func shuffleUp(_ count: Int) {
        var currentJokerLocation = jokerLocationMem.last!
        
        let modularCount = count % cardCount
        
        currentJokerLocation = (currentJokerLocation + modularCount)
        currentJokerLocation = currentJokerLocation % cardCount
        
        jokerLocationMem.append(currentJokerLocation)
    }
}


private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

