import Foundation

//ABD
//ABABD
struct Problem5582 {
    
    var string1: [Character] = []
    var string2: [Character] = []
    
    mutating func solve() {
        read()
        print(string1.longestCommonSubarrayLength(with: string2))
    }
    
    mutating func read() {
        self.string1 = [Character](readLine()!)
        self.string2 = [Character](readLine()!)
    }
}

private extension Array where Element: Equatable {
    /// 두 배열 사이에서 가장 긴 연속된 공통 부분(subarray)의 길이를 반환합니다.
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

