//
//  Array + cartesianProduct.swift
//  PageCollection
//
//  Created by 노우영 on 9/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Array where Element: Collection {
    /// 2차원 배열의 카테시안 곱을 계산합니다.
    ///
    /// 카르테시안 곱(Cartesian Product)이란, 여러 집합에서 각각의 집합에서 하나씩 원소를 선택하여 만들 수 있는
    /// 모든 가능한 순서쌍(또는 그 이상의 튜플)을 구하는 방법입니다.
    ///
    /// 예를 들어, 두 배열 `[[1, 2], [3, 4]]`이 주어졌을 때, 각 배열에서 하나씩 원소를 선택하여 가능한 모든 조합을 구하면:
    /// - (1, 3)
    /// - (1, 4)
    /// - (2, 3)
    /// - (2, 4)
    ///
    /// 즉, 카르테시안 곱은 가능한 모든 조합을 계산하는 것입니다.
    ///
    /// 이 함수는 주어진 2차원 배열의 카르테시안 곱을 계산하며, 배열의 각 원소는 하나의 집합으로 간주됩니다.
    /// 각 집합(배열)에서 하나씩 원소를 선택해 가능한 모든 경우의 수를 반환합니다.
    ///
    /// - Returns: 카르테시안 곱의 결과를 담은 배열. 각 배열은 가능한 조합을 나타냅니다.
    ///
    /// 예시:
    /// ```
    /// let arrays = [[1, 2], [3, 4]]
    /// let result = arrays.cartesianProduct
    /// print(result) // [[1, 3], [1, 4], [2, 3], [2, 4]]
    /// ```
    var cartesianProduct: [[Element.Element]] {
        return self.reduce([[]]) { (result, array) in
            // 현재까지 계산된 조합인 result 배열을 반복하여 각 배열에 대해 처리합니다.
            result.flatMap { product in
                array.map { element in
                    // 다른 1차원 배열을 이용해서 만들어진 조합에, 현재 1차원 배열의 원소를 한개씩 추가해서 반환합니다.
                    product + [element]
                }
            }
        }
    }
}
