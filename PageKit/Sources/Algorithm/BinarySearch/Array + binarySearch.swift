//
//  Array + binarySearch.swift
//  PageCollection
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    /// 주어진 연산을 사용하 이진 탐색을 합니다. comparator의 연산자에 따라 lowerBound, upperBound가 결정되는 것에 주의합니다.
    /// 배열은 미리 정렬되어 있어야 합니다.
    /// - Parameters:
    ///   - value: 탐색할 값
    ///   - comparator: 비교 조건을 정의하는 클로저 (기본값으로 `<=` 사용)
    /// - Returns: 주어진 값보다 큰 첫 번째 요소의 인덱스, 없으면 배열의 크기
    func binarySearch(_ value: Element, using comparator: (Element, Element) -> Bool) -> Int {
        var low = 0
        var high = self.count
        
        while low < high {
            let mid = (low + high) / 2
            if comparator(self[mid], value) {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
}
