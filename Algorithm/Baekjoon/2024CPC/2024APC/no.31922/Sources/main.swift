//
//  main.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/29/24.
//

import Foundation

let prize: [Int] = readArray()

let case1 = prize[0] + prize[2]

print(max(case1, prize[1]))



func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

extension Array {
    /// 배열의 원소들로부터 원하는 개수의 조합을 생성합니다.
    /// - Parameter k: 선택할 원소의 개수
    /// - Returns: 생성된 조합들의 배열
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


