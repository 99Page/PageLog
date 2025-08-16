//
//  DateFormatter.swift
//  PageKit
//
//  Created by 노우영 on 8/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct DateParser {
    
    /// 고정된 포맷 문자열을 기준으로 문자열을 Date로 변환합니다.
    /// - Parameters:
    ///   - withFormat: "yyyy-MM-dd'T'HH:mm:ss" 같은 고정 포맷
    ///   - string: 변환할 날짜 문자열
    /// - Returns: 변환된 Date. 파싱 실패 시 assertion을 남기고 `.distantPast`를 반환합니다.
    static func parse(withFormat format: String, string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        
        return formatter.date(from: string)
    }
}
