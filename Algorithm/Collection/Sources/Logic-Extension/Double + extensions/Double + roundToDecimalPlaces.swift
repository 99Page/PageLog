//
//  Dobule + roundToDecimalPlaces.swift
//  PageCollection
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Double {
    /// 소수점 이하 특정 자리수까지 반올림하는 함수
    /// - Parameter decimalPlaces: 반올림할 소수점 이하 자리수
    /// 예시:
    /// 1.125에 대해 `roundToDecimalPlaces(2)`를 호출하면, 1.13으로 수정됩니다.
    mutating func roundToDecimalPlaces(_ decimalPlaces: Int) {
        let multiplier = pow(10.0, Double(decimalPlaces))
        self = (self * multiplier).rounded() / multiplier
    }
}
