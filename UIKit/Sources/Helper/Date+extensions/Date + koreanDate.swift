//
//  Date + koreanDate.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

extension Date {
    /// Date를 지정된 시간 형식과 시간대로 포맷하여 문자열로 반환하는 함수
    /// - Parameters:
    ///   - hourDigit: 표시할 시간의 자리수. ex) 7시 or 07시
    ///   - timeZone: 사용할 시간대 (기본값은 GMT)
    /// - Returns: 포맷된 시간과 분을 포함하는 문자열
    func formatToHourAndMinute(timeZone: TimeZone = .gmt) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 표시를 위해 설정
        
        return formatter.string(from: self)
    }
}
