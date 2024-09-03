//
//  Date + createDate.swift
//  PageCollection
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Date {
    
    /// 특정 연도, 월, 일, 시, 분, 초 및 시간대를 사용하여 Date 객체를 초기화하는 이니셜라이저
    /// 입력된 값을 그대로 사용하기 위해 기본 시간대를 GMT로 설정합니다.
    /// `String` 타입으로 변경 시 `DateFormatter`의 TimeZone에 유의합니다. 
    /// - Parameters:
    ///   - year: 연도 (선택 사항, 기본값은 nil)
    ///   - month: 월 (선택 사항, 기본값은 nil)
    ///   - day: 일 (선택 사항, 기본값은 nil)
    ///   - hour: 시 (선택 사항, 기본값은 nil)
    ///   - minute: 분 (선택 사항, 기본값은 nil)
    ///   - second: 초 (선택 사항, 기본값은 nil)
    ///   - timeZone: 사용할 시간대 (기본값은 GMT)
    init?(year: Int? = nil, month: Int? = nil, day: Int? = nil,
         hour: Int? = nil, minute: Int? = nil, second: Int? = nil,
          timeZone: TimeZone = .gmt) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        var calendar: Calendar = Calendar.current
        calendar.timeZone = timeZone
        let date = calendar.date(from: dateComponents)
        
        if date != nil {
            self = date!
        } else {
            return nil
        }
    }
}
