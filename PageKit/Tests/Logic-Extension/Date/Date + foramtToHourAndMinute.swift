//
//  Date + foramtToHourAndMinute.swift
//  PageCollectionTests
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import XCTest
@testable import PageCollection

extension DateTests {
    func testFormatToHourAndMinute_WhenHourDigitIsTwo_ShouldReturnsTwoDigitHourString() {
        // When
        let birthDayString = myBirthDay.formatToHourAndMinute(hourDigit: .two)
        
        // Then
        let expectedString = "01 02"
        XCTAssertEqual(birthDayString, expectedString)
    }
    
    func testFormatToHourAndMinute_WhenHourDigitIsTwo_ShouldReturnsOneDigitHourString() {
        // When
        let birthDayString = myBirthDay.formatToHourAndMinute(hourDigit: .one)
        
        // Then
        let expectedString = "1 02"
        XCTAssertEqual(birthDayString, expectedString)
    }
}
