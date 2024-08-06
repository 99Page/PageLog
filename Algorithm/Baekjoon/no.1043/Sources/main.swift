//
//  Concurrency.swift
//
//  Created by 노우영 on 6/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

let (n, m) = readInput()

/// 설계가 부족했다. 굳이 Set으로 할 필요가 없었다.
let knowns = readKnows()
var parents: [Int] = []

let participantsInParty = readParents()

var result: Int = 0

for firstPaticipant in participantsInParty {
    updateResultCount(participantNumber: firstPaticipant)
}

print(result)

/// 주어진 참여자의 번호를 모든 진실을 아는 사람의 부모와 확인해서
/// 모든 진실을 아는 사람의 부모와 다른 경우 result를 증가시킵니다. 
func updateResultCount(participantNumber: Int) {
    result += 1
    
    for known in knowns {
        if getParents(int: participantNumber) == getParents(int: known) {
            result -= 1
            return
        }
    }
}


/// 사람의 수 n과 파티의 수 m을 입력받습니다.
/// - Returns: 사람의 수 n, 파티의 수 m
func readInput() -> (Int, Int) {
    let input = readLine() ?? ""
    let splited = input.split(separator: " ")
    let result = splited.map { Int($0)! }
    return (result[0], result[1])
}

/// 진실을 아는 사람을 입력받습니다.
/// - Returns: 진실을 아는 사람들이 저장된 Set
func readKnows() -> Set<Int> {
    let input = readLine() ?? ""
    let splited = input.split(separator: " ")
    
    var result: Set<Int> = .init()
    
    for (index, sequence) in splited.enumerated() {
        if index == 0 {
            continue
        } else {
            result.insert(Int(sequence)!)
        }
    }
    
    return result
}

/// 파티에 참여할 사람들을 입력받고, 관계를 맺습니다.
/// - Returns: 파티에 참여한 사람 중 첫번째로 입력된 사람.
func readParents() -> [Int] {
    for index in 0..<n+1 {
        parents.append(index)
    }
    
    var result: [Int] = .init(repeating: 0, count: m)
    
    for partyIndex in 0..<m {
        let input = readLine() ?? ""
        let splited = input.split(separator: " ")
        
        var parent: Int = -1
        
        for (index, sequence) in splited.enumerated() {
            if index == 0 {
                continue
            } else if index == 1 {
                parent = Int(sequence)!
            } else {
                let current = Int(sequence)!
                union(lhs: parent, rhs: current)
            }
        }
        
        result[partyIndex] = parents[parent]
    }
    
    return result
}

/// 주어진 두 숫자의 관계를 맺습니다.
func union(lhs: Int, rhs: Int) {
    let a = getParents(int: lhs)
    let b = getParents(int: rhs)
    
    if a < b {
        parents[b] = a
    } else {
        parents[a] = b
    }
}

/// 주어진 숫자의 부모를 찾고, 상황에 따라 갱신합니다.
/// - Returns: 부모 번호
func getParents(int: Int) -> Int {
    if parents[int] == int {
        return int
    } else {
        parents[int] = getParents(int: parents[int])
        return parents[int]
    }
}
