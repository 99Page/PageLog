//
//  Solver6603.swift
//  baekjoon-solve
//
//  Created by 노우영 on 10/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation



struct Solver6603 {
    static func solve() {
        var input: [Int] = readArray()
        let combinationCount = 6
        
        while input[0] != 0 {
            let candidates = Array(input[1..<input.count])
            let combinations = candidates.combinations(of: combinationCount)
            print(combinations.joinedString2D() + "\n")
            
            input = readArray()
        }
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

private extension Array where Element: Collection, Element.Element: LosslessStringConvertible {
    /// 2차원 배열의 각 요소를 문자열로 변환한 후 각 행을 지정된 구분자로 결합하고, 행들은 `\n`으로 구분하여 반환합니다.
    /// - Parameter separator: 각 행 내의 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString2D(with separator: String = " ") -> String {
        self.map { row in
            row.map(String.init).joined(separator: separator)
        }.joined(separator: "\n")
    }
}



private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}



private extension Array {
    /// 배열의 원소들로부터 원하는 개수의 조합을 생성합니다.
    /// - Parameter k: 선택할 원소의 개수
    /// - Returns: 생성된 조합들의 배열
    ///
    /// 시간 복잡도:
    /// 이 함수는 재귀적으로 호출되며, 각 호출에서 두 가지 선택을 합니다 (첫 번째 원소를 포함하거나 포함하지 않거나).
    /// n개의 원소 중 k개의 원소를 선택하는 모든 조합을 계산할 때의 시간 복잡도는 O(nCk),
    /// 즉 조합의 경우의 수와 동일하게 됩니다.
    /// 이 함수는 O(nCk)의 시간이 소요됩니다.
    /// nCk는 n! / (k! * (n - k)!)로, 일반적으로 O(2^n)에 가까운 값이 될 수 있습니다.
    func combinations(of k: Int) -> [[Element]] {
        guard k > 0 else { return [[]] }
        guard let first = self.first else { return [] }
        
        let subarray = Array(self.dropFirst())
        
        /// 배열의 첫번째 원소에서 하나를 고르고 나머지 원소를 이용해 조합합니다.
        let withFirst = subarray.combinations(of: k - 1).map { [first] + $0 }
        
        /// 배열의 첫번째 원소를 제외한 나머지를 이용해 조합합니다.
        let withoutFirst = subarray.combinations(of: k)
        
        return withFirst + withoutFirst
    }
}

