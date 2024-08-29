////
////  main.swift
////  2024.APC
////
////  Created by 노우영 on 8/29/24.
////  Copyright © 2024 Page. All rights reserved.
////
//
//import Foundation
//
///// - Conditions
/////
///// Shake 선발 기준
///// [v] 아주대 학생
///// [v] ICPC 비수상자
///// [v] shake 3위 이내 비수상자
///// [v] APC 성적 순 최대 10명
/////
//
//let apcParticipantCount = Int(readLine()!)!
//let participants: [APCParticipant] = readParticipants()
//
//solve()
//
//func solve() {
//    var result: [APCParticipant] = []
//    
//    for participant in participants {
//        if participant.canParticipantToShake {
//            result.append(participant)
//        }
//        
//        if result.count >= 10 {
//            break
//        }
//    }
//    
//    assert(result.count <= 10)
//    
//    print(result.count)
//    let names = result.map { $0.name }.sorted().joined(separator: "\n")
//    print(names)
//}
//
//func readParticipants() -> [APCParticipant] {
//    var result: [APCParticipant] = []
//    
//    (0..<apcParticipantCount).forEach { _ in
//        let line = readLine()!
//        let participant = APCParticipant(line: line)
//        result.append(participant)
//    }
//    
//    result.sort { $0.apcRank < $1.apcRank }
//    return result
//}
//
//
//struct APCParticipant {
//    let name: String
//    let state: State
//    let isICPCWinner: Bool
//    let topShakeRank: Int
//    let apcRank: Int
//    
//    init(line: String) {
//        let splitedLine = line.split(separator: " ")
//        self.name = String(splitedLine[0])
//        self.state = State(rawValue: String(splitedLine[1]))!
//        
//        self.isICPCWinner = String(splitedLine[2]) == "winner"
//        self.topShakeRank = Int(splitedLine[3])!
//        self.apcRank = Int(splitedLine[4])!
//    }
//    
//    var canParticipantToShake: Bool {
//        state == .jaehak && !isICPCWinner
//        && (topShakeRank > 3 || topShakeRank == -1)
//    }
//    
//    
//    enum State: String {
//        case jaehak
//        case hewhak
//    }
//}
