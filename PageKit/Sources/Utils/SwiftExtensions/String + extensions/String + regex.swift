//
//  String + regex.swift
//  PageKit
//
//  Created by 노우영 on 12/13/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

extension String {
    /**
     주어진 정규 표현식 패턴에 문자열 전체가 일치하는지 확인합니다.
     
     - Parameter pattern: 검사할 정규 표현식 문자열입니다.
     - Returns: 문자열이 패턴과 일치하면 true, 아니면 false.
     */
    func matchesRegex(_ pattern: String) -> Bool {
        // 문자열이 비어있으면 매치할 수 없음
        guard !self.isEmpty else { return false }
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let fullRange = NSRange(location: 0, length: self.utf16.count)
            let match = regex.firstMatch(in: self, options: [], range: fullRange)
            return match != nil
            
        } catch {
            return false
        }
    }
}
