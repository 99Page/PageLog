//
//  formattedToOneDigitHourMinute.swift
//  PageCollection
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Date {
    /// Date를 지정된 시간 형식과 시간대로 포맷하여 문자열로 반환하는 함수
    /// - Parameters:
    ///   - hourDigit: 표시할 시간의 자리수. ex) 7시 or 07시
    ///   - timeZone: 사용할 시간대 (기본값은 GMT)
    /// - Returns: 포맷된 시간과 분을 포함하는 문자열
    func formatToHourAndMinute(hourDigit: HourDigit, timeZone: TimeZone = .gmt) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = hourDigit.format
        formatter.timeZone = timeZone
        
        return formatter.string(from: self)
    }
    
    enum HourDigit {
        case one
        case two
        
        var format: String {
            switch self {
            case .one:
                "H mm"
            case .two:
                "hh mm"
            }
        }
    }
}
