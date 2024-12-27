//
//  Solver10816.swift
//  baekjoon-solve
//
//  Created by 노우영 on 12/27/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

struct Solver10816 {
    
    let cardCount: Int
    let targetCount: Int
    
    let cards: [Int]
    let targets: [Int]
    
    init() {
        self.cardCount = Int(readLine()!)!
        self.cards = readArray()
        
        self.targetCount = Int(readLine()!)!
        self.targets = readArray()
    }
    
    func solve() {
        var result: [Int] = []
        var appearance: [Int: Int] = [:]
        
        for card in cards {
            let appearanceCount = appearance[card] ?? 0
            let newAppearanceCount = appearanceCount + 1
            appearance.updateValue(newAppearanceCount, forKey: card)
        }
        
        for target in targets {
            result.append(appearance[target] ?? 0)
        }
        
        print(result.joinedString())
    }
}

private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splited = line.split(separator: " ")
    return splited.map { T(String($0))! }
}
