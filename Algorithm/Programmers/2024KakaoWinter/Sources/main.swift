//
//  main.swift
//  2024.kakao.winter
//
//  Created by 노우영 on 9/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

var dices: [[Int]] = []
var maxWin: Int = 0
var goodDice: [Int] = []

func solution(_ dice:[[Int]]) -> [Int] {
    dices = dice
    
    let diceCandidates = Array(0..<dice.count)
    let diceCombinations = diceCandidates.combinations(of: dice.count / 2)
    
    let halfDiceCombinations = diceCombinations[0..<diceCombinations.count / 2]
    let halfDiceCombinations2 = Array(diceCombinations[diceCombinations.count / 2..<diceCombinations.count].reversed())
    
    for index in halfDiceCombinations.indices {
        compare(combination1: halfDiceCombinations[index], combination2: halfDiceCombinations2[index])
    }
    
    print(goodDice.map({ $0 + 1 }))
    return goodDice.map { $0 + 1}
}

func compare(combination1: [Int], combination2: [Int]) {
    let case1 = findCases(combination: combination1)
    let case2 = findCases(combination: combination2)
    
    var case1WinCount = 0
    var case2WinCount = 0
    
    for case2Element in case2 {
        let upperBoundIndex = case1.findUpperBound(case2Element)
        let lowerBoundIndex = case1.findLowerBound(case2Element)
        
        let comb1WinCount = case1.count - upperBoundIndex
        let comb2WinCount = lowerBoundIndex
        
        case1WinCount += comb1WinCount
        case2WinCount += comb2WinCount
    }
    
    if case1WinCount > maxWin {
        maxWin = case1WinCount
        goodDice = combination1
    }
    
    if case2WinCount > maxWin {
        maxWin = case2WinCount
        goodDice = combination2
    }
}

func findCases(combination: [Int] ) -> [Int] {
    var targetDices: [[Int]] = []
    var result: [Int] = []
    
    for diceIndex in combination {
        targetDices.append(dices[diceIndex])
    }
    
    let sums = targetDices.cartesianProduct()
    
    for sum in sums {
        let sum = sum.reduce(into: 0) { partialResult, value in
            partialResult += value
        }
        result.append(sum)
    }
    
    return result.sorted()
}

extension Array {
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

extension Array where Element: Collection {
    /// 2차원 배열의 카테시안 곱을 계산합니다.
    /// - Returns: 카테시안 곱 결과 배열
    func cartesianProduct() -> [[Element.Element]] {
        return self.reduce([[]]) { (result, array) in
            result.flatMap { product in
                array.map { element in
                    product + [element]
                }
            }
        }
    }
}


extension Array where Element: Comparable {
    /// 이진 탐색을 사용하여 배열에서 주어진 값보다 크거나 같은 첫 번째 위치를 반환합니다.
    ///
    /// 배열은 미리 정렬되어 있어야 합니다.
    /// - Parameter value: 탐색할 값
    /// - Returns: 주어진 값보다 크거나 같은 첫 번째 요소의 인덱스, 없으면 배열의 크기
    func findLowerBound(_ value: Element) -> Int {
        var low = 0
        var high = self.count
        
        while low < high {
            let mid = (low + high) / 2
            if self[mid] < value {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
}



extension Array where Element: Comparable {
    /// 이진 탐색을 사용하여 배열에서 주어진 값보다 큰 첫 번째 위치를 반환합니다.
    ///
    /// 배열은 미리 정렬되어 있어야 합니다.
    /// - Parameter value: 탐색할 값
    /// - Returns: 주어진 값보다 큰 첫 번째 요소의 인덱스, 없으면 배열의 크기
    func findUpperBound(_ value: Element) -> Int {
        var low = 0
        var high = self.count
        
        while low < high {
            let mid = (low + high) / 2
            if self[mid] <= value {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
}
