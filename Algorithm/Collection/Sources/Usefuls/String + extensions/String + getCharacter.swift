//
//  String + getCharacter.swift
//  PageCollection
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension String {
    /// 문자열의 특정 인덱스에 있는 문자를 반환하는 함수
    /// - Parameter index: 반환할 문자 위치의 인덱스
    /// - Returns: 해당 위치에 있는 문자 (인덱스가 유효하지 않으면 nil 반환)
    func getCharacter(at index: Int) -> Character? {
        /// 인덱스가 유효한지 확인
        guard index >= 0 && index < self.count else { return nil }
        
        /// String.Index로 변환
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        
        /// 해당 위치의 문자 반환
        return self[stringIndex]
    }
}
