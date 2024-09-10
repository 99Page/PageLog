//
//  Array + compbinations.swift
//  PageCollection
//
//  Created by 노우영 on 8/27/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Array {
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
