//
//  String + formatDouble.swift
//  PageKit
//
//  Created by 노우영 on 11/10/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

extension String {
    /// 주어진 Double 값을 반올림하여 지정된 소수점 자리수까지 포맷한 문자열을 반환한다.
    /// - Parameters:
    ///   - value: 포맷할 Double 값.
    ///   - digits: 표시할 소수점 자리수 (기본값은 2).
    /// - Returns: 반올림된 문자열.
    ///
    /// ### 예시
    /// ```swift
    /// let rounded = String.round(3.1459, digits: 2)
    /// print(rounded) // "3.15"
    /// ```
    static func round(_ value: Double, digits: Int = 2) -> String {
        let scale = pow(10.0, Double(digits))
        let roundedValue = Darwin.round(value * scale) / scale
        return String(format: "%.\(digits)f", roundedValue)
    }

    /// 주어진 Double 값을 내림하여 지정된 소수점 자리수까지 포맷한 문자열을 반환한다.
    /// - Parameters:
    ///   - value: 포맷할 Double 값.
    ///   - digits: 표시할 소수점 자리수 (기본값은 2).
    /// - Returns: 내림된 문자열.
    ///
    /// ### 예시
    /// ```swift
    /// let floored = String.floor(3.1499, digits: 2)
    /// print(floored) // "3.14"
    /// ```
    static func floor(_ value: Double, digits: Int = 2) -> String {
        let scale = pow(10.0, Double(digits))
        let flooredValue = Darwin.floor(value * scale) / scale
        return String(format: "%.\(digits)f", flooredValue)
    }

    /// 주어진 Double 값을 올림하여 지정된 소수점 자리수까지 포맷한 문자열을 반환한다.
    /// - Parameters:
    ///   - value: 포맷할 Double 값.
    ///   - digits: 표시할 소수점 자리수 (기본값은 2).
    /// - Returns: 올림된 문자열.
    ///
    /// ### 예시
    /// ```swift
    /// let ceiled = String.ceil(3.1411, digits: 2)
    /// print(ceiled) // "3.15"
    /// ```
    static func ceil(_ value: Double, digits: Int = 2) -> String {
        let scale = pow(10.0, Double(digits))
        let ceiledValue = Darwin.ceil(value * scale) / scale
        return String(format: "%.\(digits)f", ceiledValue)
    }
}
