//
//  Solver3665.swift
//  baekjoon-solve
//
//  Created by 노우영 on 5/23/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

/// 백준 3665번 풀이
///
/// # 문제 접근
/// 1. 브루트포스는 시간 복잡도 계산 불가능
/// 2. DP로는 풀이 불가능. 재방문하는 케이스가 아니고, 인덱스의 순서에 의미를 줄 수 있는게 없음.
/// 3. 문제가 자연스럽게 분할되지 않으므로 DC도 아님.
///
/// 문제에서는 '순위' 라는 관계가 있으니 그래프 문제 혹은, 어떤 기준에 의해 Greedy하게 순위를 설정할 수 있으니 그리디로 접근할 수 있었습니다.
/// '순위' 를 관계로 봤을 때 a_i, b_i 는 관계가 뒤집히는 걸로 접근할 수 있고 그래프 문제로 접근한다면 indegree를 세서 문제를 해결할 수 있을거라고 파악했습니다.
struct Solver3665 {
    var inputSequence: [Int] = []
    
    var swapInfo: [[Int]] = []
    var teamCount = 0
    var indegrees: [Int] = []
    
    var outputs: [String] = []

    init() { }
    
    /// 문제 풀이를 위한 최초 진입 지점입니다.
    mutating func solve() {
        let testCase = Int(readLine()!)!
        
        (0..<testCase).forEach { _ in
            solveTest()
        }
        
        printOutput()
    }
    
    /// 각 테스트 마다 주어진 입력 값을 읽고, `outputs` 배열에 각 테스트의 출력값 추가합니다.
    private mutating func solveTest() {
        readSequence()
        readSwapInfo()
        makeIndegree()
        addOutput()
    }
    
    private func printOutput() {
        print(outputs.joined(separator: "\n"))
    }
    
    private mutating func addOutput() {
        var teamRanks = [TeamRank]()
        
        (1...teamCount).forEach { index in
            teamRanks.append(TeamRank(teamNumber: index, rank: indegrees[index]))
        }
        
        teamRanks.sort { $0.rank < $1.rank }
        
        var expectedRank = 0
        
        for teamRank in teamRanks {
            // 정상적인 경우라면 팀의 순서는 반드시 0~team.count - 1 순으로 정렬됨.
            if teamRank.rank != expectedRank {
                outputs.append("IMPOSSIBLE")
                return
            }
            
            expectedRank += 1
        }
        
        let newSequence = teamRanks.map { "\($0.teamNumber)" }.joined(separator: " ")
        outputs.append(newSequence)
    }
    
    /// 입력으로 주어진 순서를 읽고 배열에 저장합니다
    private mutating func readSequence() {
        teamCount = Int(readLine()!)!
        inputSequence = readArray()
    }
    
    /// 입력으로 주어진 변경된 순서 정보를 읽고 배열에 저장합니다
    private mutating func readSwapInfo() {
        let swapCount = Int(readLine()!)!
        swapInfo = Array(repeating: Array(repeating: 0, count: 0), count: teamCount + 1)
        
        (0..<swapCount).forEach { _ in
            let swapInput: [Int] = readArray()
            let value1 = swapInput[0]
            let value2 = swapInput[1]
            swapInfo[value1].append(value2)
            swapInfo[value2].append(value1)
        }
    }
    
    /// 주어진 입력 값들을 이용해 각 팀의 indegree를 셉니다.
    private mutating func makeIndegree() {
        indegrees = Array(repeating: 0, count: teamCount + 1)
        
        var visitTeams: Set<Int> = []
        
        // 입력에서 주어진 순서대로 indgree 추가
        for index in 0..<teamCount {
            let teamNumber = inputSequence[index]
            let swapedTeams = swapInfo[teamNumber]
            
            // 현재 보고 있는 팀의, 변경된 순서 정보 확인
            indegrees[teamNumber] = visitTeams.count
            
            for swapedTeam in swapedTeams {
                if !visitTeams.contains(swapedTeam) {
                    indegrees[teamNumber] += 1 // 방문하지 않았는데 순서가 변경됐다면 현재 팀보다 앞에 배치
                } else {
                    indegrees[teamNumber] -= 1 // 방문했는데 순서가 변경됐다면 현재 팀보다 뒤에 배치
                }
            }
            
            visitTeams.insert(teamNumber)
        }
    }
    
    struct TeamRank {
        let teamNumber: Int
        let rank: Int
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

