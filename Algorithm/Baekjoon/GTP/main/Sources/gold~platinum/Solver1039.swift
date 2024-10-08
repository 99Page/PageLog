//
//  Solver1039.swift
//  gold-platinum-solver
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation


/// 최소한의 순회를 하면서 크기순으로 정렬하는 문제.
/// 배열을 전부 순회하고, 크기순 + 인덱스 순으로 정렬해서 PQ에 넣는다.
/// 큰 값, 그리고 자리수가 뒤에 있는 값부터 앞에 있는 숫자와 교체한다.
/// 전체 교체가 끝난 이후에는 (교체 개수 k가 자리수 m보다 크거나 같은 경우)
/// 뒤에 있는 두 자리만 계속 교체한다.
/// 여기서 생기는 예외 상황:
/// 자리수 교체가 된 숫자가 Queue에 남아있을 때의 처리
/// Dictionary 만들어서 교체되었다면 무시.
struct Solver1039 {
    let swapCount: Int
    let initialValue: Int
    private let maxValue = 1_000_000
    
    /// 첫번째 인덱스: 교환한 횟수
    /// 두번째 인덱스: 해당 값
    /// 배열의 의미: 해당 교환 횟수의 해당 값에서 숫자 교체 후 나올 수 있는 최대값
    var mem: [[Int]]
    
    init() {
        let input: [Int] = readArray()
        self.initialValue = input[0]
        self.swapCount = input[1]
        
        let swapArray = Array(repeating: -1, count: maxValue + 1)
        self.mem = Array(repeating: swapArray, count: swapCount + 1)
    }
    
    mutating func solve() {
        let result = swap(currentSwapCount: 0, currentValue: initialValue)
        print(result)
    }
    
    mutating func swap(currentSwapCount: Int, currentValue: Int) -> Int {
        guard currentValue.digitCount == initialValue.digitCount else { return -1 }
        
        guard mem[currentSwapCount][currentValue] == -1 else {
            return mem[currentSwapCount][currentValue]
        }
        
        guard currentSwapCount < swapCount else {
            mem[currentSwapCount][currentValue] = currentValue
            return currentValue
        }
        
        var currentMaxValue: Int = -1
        let valueString = String(currentValue)
        
        for i in 0..<valueString.count {
            for j in i+1..<valueString.count {
                let swappedString = valueString.swapCharacters(at: i, and: j)
                let maxValue = swap(currentSwapCount: currentSwapCount + 1, currentValue: Int(swappedString)!)
                currentMaxValue = max(currentMaxValue, maxValue)
            }
        }
        
        mem[currentSwapCount][currentValue] = currentMaxValue
        return mem[currentSwapCount][currentValue]
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
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

private extension String {
    /// 문자열의 두 인덱스에 있는 문자를 서로 교체하는 함수. 주어진 인덱스가 유효하지 않으면 자기 자신을 반환.
    /// - Parameters:
    ///   - firstIndex: 첫 번째 문자 위치의 인덱스
    ///   - secondIndex: 두 번째 문자 위치의 인덱스
    /// - Returns: 문자가 교체된 새로운 문자열
    func swapCharacters(at firstIndex: Int, and secondIndex: Int) -> String {
        /// 인덱스가 유효한지 확인
        guard firstIndex >= 0 && firstIndex < self.count &&
                secondIndex >= 0 && secondIndex < self.count else { return self }
        
        /// String.Index로 변환
        let firstStringIndex = self.index(self.startIndex, offsetBy: firstIndex)
        let secondStringIndex = self.index(self.startIndex, offsetBy: secondIndex)
        
        /// 문자 교체
        var newString = self
        let firstChar = newString[firstStringIndex]
        let secondChar = newString[secondStringIndex]
        
        newString.replaceSubrange(firstStringIndex...firstStringIndex, with: String(secondChar))
        newString.replaceSubrange(secondStringIndex...secondStringIndex, with: String(firstChar))
        
        return newString
    }
}

private extension Int {
     /// - Returns: 정수의 자리수
    var digitCount: Int {
         return String(abs(self)).count
    }
}
