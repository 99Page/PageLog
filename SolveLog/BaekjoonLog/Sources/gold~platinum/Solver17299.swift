//
//  Solver17299.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver17299 {
    /// 반복적으로 배열을 순회할 때(O(n^2)) 시간을 줄이는 방법은 두가지가 있다.
    /// 1. 이전 방문을 스택으로 저장해서 다음 방문에 재활용하기
    /// 2. 스택의 parent-child 관계를 만들어서 순회의 short cut 만들어주기

    //21
    //1 2 2 3 3 3 4 4 4 4 5 5 5 5 5 6 6 6 6 6 6

    //21
    //6 6 6 6 6 6 5 5 5 5 5 4 4 4 4 3 3 3 2 2 1

    //4
    //2 3 3 2

    //5
    //2 3 3 3 2

    //등장회수를 다음처럼 만들어보자
    //2(1) 1(2) 3(3) 4(4) 1(5) 5(6)
    //21
    //1 3 4 5 6 3 4 5 6 4 5 6 5 6 6 1 2 3 4 5 6

    //6
    //4 2 2 1 3 3

    //8
    //4 1 1 2 3 3 4 4
    //Output
    //-1 4 4 3 4 4 -1 -1

    //9
    //4 1 1 2 3 3 3 4 4
    //Output
    //-1 3 3 3 -1 -1 -1 -1 -1

    /// key: 수열의 원소
    /// value: 등장 회수
    var frequencyCount: [Int: Int] = [:]

    let sequenceSize: Int
    let sequence: [Int]
    var ngtIndex: [Int]
    var ngts: [Int] = []
    
    init() {
        self.sequenceSize = Int(readLine()!)!
        self.sequence = readSequence()
        self.ngtIndex = Array(repeating: -1, count: sequenceSize)
    }


    mutating func solve() {
        initSequenceInformation()
        fillNGTIndex()
        print(ngts.reversed().map { "\($0)" }.joined(separator: " "))
    }

    mutating func fillNGTIndex() {
        /// 마지막 배열의 jump는 -1로 고정입니다.
        var index = sequenceSize - 2
        appendNGTPrint(index: -1)
        
        while index >= 0 {
            var targetIndex = index + 1
            
            /// targetIndex가 현재 index의 등장 회수보다. 많을 때까지 계속 이동합니다.
            while targetIndex != -1 {
                let targetElement = sequence[targetIndex]
                let currentElement = sequence[index]
                
                let targetElementFrequencyCount = frequencyCount[targetElement]!
                let currentElementFrequencyCount = frequencyCount[currentElement]!
                
                if targetElementFrequencyCount > currentElementFrequencyCount {
                    ngtIndex[index] = targetIndex
                    break
                } else if targetElementFrequencyCount == currentElementFrequencyCount {
                    ngtIndex[index] = ngtIndex[targetIndex]
                    break
                } else {
                    targetIndex = ngtIndex[targetIndex]
                }
            }
            
            appendNGTPrint(index: ngtIndex[index])
            index -= 1
        }
    }

    mutating func appendNGTPrint(index: Int) {
        if index == -1 {
            ngts.append(-1)
        } else {
            let element = sequence[index]
            ngts.append(element)
        }
    }

    mutating func initSequenceInformation() {
        for element in sequence {
            if frequencyCount[element] == nil {
                frequencyCount.updateValue(1, forKey: element)
            } else {
                let count = frequencyCount[element]!
                frequencyCount.updateValue(count + 1 , forKey: element)
            }
        }
    }
}

private func readSequence() -> [Int] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let sequence = splitedLine.map { Int($0)! }
    return sequence
}

