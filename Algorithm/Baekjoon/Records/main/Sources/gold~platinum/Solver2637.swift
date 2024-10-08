//
//  Solver2637.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation


/// 같은 부품의 개수는 또 안세는게 핵심.
/// 방문 회수를 줄이자.
/// 1. parent-child 관계를 만들어서 순회
/// 2. 방문 후 필요한 최소 부품 개수 저장
struct Solver2637 {
    
    let maxPartCount: Int = 100
    let partCount: Int
    
    let requiredSubparts: [[Int]]
    var inDegreeCounts: [Int]
    var requiredBaseparts: [RequiredBasePart]
    
    init() {
        self.partCount = Int(readLine()!)!
        
        let partInfoCount = Int(readLine()!)!
        
        let initialRequiredBasePart = RequiredBasePart(maxPartCount: maxPartCount)
        self.requiredBaseparts = Array(repeating: initialRequiredBasePart, count: maxPartCount + 1)
        
        let subpartsRow = Array(repeating: 0, count: maxPartCount + 1)
        var requiredSubparts: [[Int]] = Array(repeating: subpartsRow, count: maxPartCount + 1)
        
        var outDegreeCounts: [Int] = Array(repeating: 0, count: maxPartCount + 1)
        
        (0..<partInfoCount).forEach { _ in
            let partInfoInput: [Int] = readArray()
            let parentPart = partInfoInput[0]
            let childPart = partInfoInput[1]
            let neededChildPartCount = partInfoInput[2]
            
            outDegreeCounts[parentPart] += 1
            requiredSubparts[parentPart][childPart] += neededChildPartCount
        }
        
        self.requiredSubparts = requiredSubparts
        self.inDegreeCounts = outDegreeCounts
    }
    
    mutating func solve() {
        updateRequiredBasepartsForBasepart()
        
        let result = countsRequiredBasePart(partNumber: partCount, requiredCount: 1)
        var output: String = ""
        
        for partNumber in 1...maxPartCount {
            if result.required[partNumber] != 0 {
                output.append("\(partNumber) \(result.required[partNumber])\n")
            }
        }
        
        output.removeLast()
        print(output)
    }
    
    mutating func updateRequiredBasepartsForBasepart() {
        for partNumber in 1..<partCount {
            if inDegreeCounts[partNumber] == 0 {
                requiredBaseparts[partNumber].required[partNumber] = 1
            }
        }
    }
    
    mutating func countsRequiredBasePart(partNumber: Int, requiredCount: Int) -> RequiredBasePart {
        guard inDegreeCounts[partNumber] != 0 else {
            return requiredBaseparts[partNumber].multiply(count: requiredCount)
        }
        
        guard !requiredBaseparts[partNumber].isVisited else {
            return requiredBaseparts[partNumber].multiply(count: requiredCount)
        }
        
        for subpartNumber in 1...maxPartCount {
            let requiredCount = requiredSubparts[partNumber][subpartNumber]
            
            if requiredCount > 0 {
                let searchResult = countsRequiredBasePart(partNumber: subpartNumber, requiredCount: requiredCount)
                requiredBaseparts[partNumber].sum(requiredBasePart: searchResult)
                requiredBaseparts[subpartNumber].isVisited = true
            }
        }
        
        return requiredBaseparts[partNumber].multiply(count: requiredCount)
    }
    
    struct RequiredBasePart {
        var required: [Int]
        var isVisited: Bool = false
        let maxPartCount: Int
        
        init(maxPartCount: Int) {
            self.maxPartCount = maxPartCount
            required = Array(repeating: 0, count: maxPartCount + 1)
        }
        
        init(required: [Int]) {
            self.required = required
            self.maxPartCount = required.count - 1
        }
        
        mutating func sum(requiredBasePart: RequiredBasePart) {
            for index in 0..<maxPartCount {
                self.required[index] += requiredBasePart.required[index]
            }
        }
        
        func multiply(count: Int) -> RequiredBasePart {
            var result: [Int] = Array(repeating: 0, count: maxPartCount + 1)
            
            for partNumber in 0...maxPartCount {
                result[partNumber] = required[partNumber] * count
            }
            
            return RequiredBasePart(required: result)
            
        }
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}


private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}
