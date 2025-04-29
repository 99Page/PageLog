//
//  Array + lowerBound.swift
//  PageCollection
//
//  Created by 노우영 on 9/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

private extension Array where Element: Comparable {
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
