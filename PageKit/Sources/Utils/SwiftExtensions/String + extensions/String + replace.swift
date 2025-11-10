//
//  String + replace.swift
//  PageCollection
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension String {
    /// 문자열의 특정 인덱스에 있는 문자를 교체하는 함수. index가 적절하지 않은 경우 원래의 값을 반환.
    /// - Parameters:
    ///   - index: 교체할 문자 위치의 인덱스
    ///   - newChar: 교체할 문자
    /// - Returns: 문자가 교체된 새로운 문자열
    func replace(at index: Int, with newChar: Character) -> String {
        /// 인덱스가 유효한지 확인
        guard index >= 0 && index < self.count else { return self }
        
        /// String.Index로 변환
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        
        /// 문자 교체
        var newString = self
        newString.replaceSubrange(stringIndex...stringIndex, with: String(newChar))
        
        return newString
    }
}
