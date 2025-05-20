//
//  Solver9576.swift
//  baekjoon-solve
//
//  Created by 노우영 on 5/20/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

//1
//4 4
//1 1
//1 3
//2 2
//3 4

//1
//5 5
//3 3
//1 1
//2 5
//4 4
//2 3
//
//1
//5 1
//1 5

/// 문제 풀이
///
/// # 설계
///
/// 문제를 보면, 정렬을 해야겠다는 생각부터 듭니다. 어떤 기준으로 정렬할 건지 정하고 각 상황에 맞게 카운터 케이스를 찾아야합니다.
/// 주어진 범위의 시작 값을 lb, 끝 값을 ub 라고 표현하겠습니다.
///
/// 첫번째 접근. lb 오름차순, ub 오름차순
///
/// 카운터 케이스가 존재합니다.
///
/// ```
/// 1
/// 5 5
/// 1 1
/// 2 5
/// 2 3
/// 3 3
/// 4 4
/// ```
///
/// 두번째 접근. 간격 좁은 순
///
/// 마찬가지로 카운터 케이스 있습니다.
///
/// ```
/// 1
/// 4 4
/// 1 1
/// 2 2
/// 3 4
/// 1 3
/// ```
///
/// 여기까지 고려해보니, 더 고려할 것이 보입니다. 정렬도 정렬인데, 주어진 범위 내에서 어떤 값을 선택해야할지도 애매합니다. 그건 정렬한 방식에 따라 맞춰가는게 좋은 방식일 것 같습니다.
///
/// 세번째 접근. ub 오름차순, lb 오름차순, 그리고 범위 내 선택하지 않은 가장 작은 값.
///
/// 카운터 케이스는 없어 보입니다. (실제로 정답이었습니다.)
struct Solver9576 {
    let testCase: Int
    var result: [Int] = []
    
    init() {
        self.testCase = Int(readLine()!)!
    }
    
    mutating func solve() {
        (0..<testCase).forEach { _ in
            solveCase()
        }
        
        printResult()
    }
    
    private func printResult() {
        let resultString = result.map { String($0) }.joined(separator: "\n")
        print(resultString)
    }
    
    mutating func solveCase() {
        let input: [Int] = readArray()
        let rangeCount = input[1]
        
        var ranges = readRanges(rangeCount)
        ranges.sort()
        
        divideBook(ranges)
    }
    
    mutating func divideBook(_ ranges: [Range]) {
        var divided: Set<Int> = []
        
        for range in ranges {
            for i in range.lowerBound...range.upperBound {
                if !divided.contains(i) {
                    divided.insert(i)
                    break
                }
            }
        }
        
        result.append(divided.count)
    }
    
    private func readRanges(_ k: Int) -> [Range] {
        var result: [Range] = []
        
        (0..<k).forEach { _ in
            let input: [Int] = readArray()
            result.append(Range(lowerBound: input[0], upperBound: input[1]))
        }
        return result
    }
    
    struct Range: Comparable {
        static func < (lhs: Solver9576.Range, rhs: Solver9576.Range) -> Bool {
            if lhs.upperBound != rhs.upperBound {
                return lhs.upperBound < rhs.upperBound
            } else {
                return lhs.lowerBound < rhs.lowerBound
            }
        }
        
        let lowerBound: Int
        let upperBound: Int
    }
}

private func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}

