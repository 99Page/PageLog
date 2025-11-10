//
//  Array + longestCommonSubarrayLength.swift
//  PageKit
//
//  Created by 노우영 on 10/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    /// 두 배열 사이에서 가장 긴 연속된 공통 부분(subarray)의 길이를 반환.
    ///
    /// 2차원 DP를 사용해서 문제를 해결한다.
    /// dp[i][j] = self[0..<i], other[0..<j]를 비교했을 때 마지막 원소가 같은 경우 공통 부분 길이를 저장한다.
    /// 이 때 DP의 갱신 코드는 다음과 같다.
    /// ```
    /// dp[i][j] =  (self[i-1]==other[j-1]) ? dp[i-1][j-1] + 1 : 0
    /// ```
    ///
    /// 즉, 2차원 배열을 만들어도 행에 대한 배열만 확인하는 것이다. 따라서 직전의 정보를 제외하면 전부 제거해도 된다. 따라서, prev와 curr 정보만 남긴다.
    ///
    /// prev 정보를 curr로 덮어쓸 때는 swap을 사용해 메모리 참조만 변경하면, 값을 복사하는 일 없이 비용을 저렴하게 교체할 수 있다. 
    func longestCommonSubarrayLength(with other: [Element]) -> Int {
        var maxLength = 0
        let n = self.count
        let m = other.count
        
        // DP 테이블 (이전 행만 유지해서 메모리 절약)
        var prev = Array<Int>(repeating: 0, count: m + 1)
        var curr = Array<Int>(repeating: 0, count: m + 1)
        
        for i in 1...n {
            for j in 1...m {
                if self[i - 1] == other[j - 1] {
                    curr[j] = prev[j - 1] + 1
                    maxLength = Swift.max(maxLength, curr[j])
                } else {
                    curr[j] = 0
                }
            }
            
            swap(&prev, &curr)
        }
        
        return maxLength
    }
}
