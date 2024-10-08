//
//  Solver31923.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver31923 {
    let sCount: Int
    let strawberry: Int
    let shineMuscat: Int
    let maxSkewereCount: Int = 1_000

    let skeweredStrawberry: [Int]
    let skeweredShineMuscat: [Int]
    var skewereCount: [Int] = []
    
    init() {
        let input: [Int] = readArray()
        self.sCount = input[0]
        self.strawberry = input[1]
        self.shineMuscat = input[2]
        self.skeweredStrawberry = readArray()
        self.skeweredShineMuscat = readArray()
    }

    mutating func solve() {
        for index in 0..<sCount {
            let skeweredDiff = skeweredStrawberry[index] - skeweredShineMuscat[index]
            let minSkewere = findMinSkeweredCount(target: skeweredDiff)

            if minSkewere == -1 {
                print("NO")
                return
            } else {
                skewereCount.append(minSkewere)
            }
        }

        let result = skewereCount.map { String($0) }.joined(separator: " ")
        print("YES")
        print(result)
    }

    /// - Parameters:
    ///     target: 딸기가 더 많으면 양수, 샤인머스켓이 더 많으면 음수
    func findMinSkeweredCount(target: Int) -> Int {
        var count: Int = 0
        var diff = target

        while true {
            if count == maxSkewereCount {
                return -1
            }

            if diff == 0 {
                break
            }

            if diff > 0 && strawberry >= shineMuscat {
                return -1
            }

            if diff < 0 && strawberry <= shineMuscat {
                return -1
            }

            diff += (strawberry - shineMuscat)
            count += 1
        }

        return count
    }

    struct Skewere {
        let remainDiff: Int
        let count: Int
    }

    struct Queue<Element> {
        private var inStack = [Element]()
        private var outStack = [Element]()

        var isEmpty: Bool {
            inStack.isEmpty && outStack.isEmpty
        }

        mutating func enqueue(_ newElement: Element) {
            inStack.append(newElement)
        }

        mutating func dequeue() -> Element? {
            if outStack.isEmpty {
                outStack = inStack.reversed()
                inStack.removeAll()
            }

            return outStack.popLast()
        }
    }
}


private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
