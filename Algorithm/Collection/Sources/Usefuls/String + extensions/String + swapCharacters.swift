//
//  String + swapCharacters.swift
//  PageCollection
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension String {
    /// 문자열의 두 인덱스에 있는 문자를 서로 교체하는 함수. 주어진 인덱스가 유효하지 않으면 자기 자신을 반환.
    /// - Parameters:
    ///   - firstIndex: 첫 번째 문자 위치의 인덱스
    ///   - secondIndex: 두 번째 문자 위치의 인덱스
    /// - Returns: 문자가 교체된 새로운 문자열
    func swapCharacters(at firstIndex: Int, and secondIndex: Int) -> String {
        /// 인덱스가 유효한지 확인
        guard firstIndex >= 0 && firstIndex < self.count &&
                secondIndex >= 0 && secondIndex < self.count else { return self }
        
        /// String.Index로 변환
        let firstStringIndex = self.index(self.startIndex, offsetBy: firstIndex)
        let secondStringIndex = self.index(self.startIndex, offsetBy: secondIndex)
        
        /// 문자 교체
        var newString = self
        let firstChar = newString[firstStringIndex]
        let secondChar = newString[secondStringIndex]
        
        newString.replaceSubrange(firstStringIndex...firstStringIndex, with: String(secondChar))
        newString.replaceSubrange(secondStringIndex...secondStringIndex, with: String(firstChar))
        
        return newString
    }
}
