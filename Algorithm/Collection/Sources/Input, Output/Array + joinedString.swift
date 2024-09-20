//
//  Output.swift
//  PageCollection
//
//  Created by 노우영 on 8/30/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

private extension Array where Element: LosslessStringConvertible {
    /// 배열의 각 요소를 문자열로 변환한 후 지정된 구분자로 결합하여 반환합니다.
    /// - Parameter separator: 각 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString(with separator: String = " ") -> String {
        self.map(String.init).joined(separator: separator)
    }
}

private extension Array where Element: Collection, Element.Element: LosslessStringConvertible {
    /// 2차원 배열의 각 요소를 문자열로 변환한 후 각 행을 지정된 구분자로 결합하고, 행들은 `\n`으로 구분하여 반환합니다.
    /// - Parameter separator: 각 행 내의 문자열 요소를 결합할 때 사용할 구분자
    /// - Returns: 결합된 문자열
    func joinedString2D(with separator: String = " ") -> String {
        self.map { row in
            row.map(String.init).joined(separator: separator)
        }.joined(separator: "\n")
    }
}
