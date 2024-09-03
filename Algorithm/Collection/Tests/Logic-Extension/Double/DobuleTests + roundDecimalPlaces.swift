//
//  DobuleTests + roundDecimalPlaces.swift
//  PageCollectionTests
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import XCTest
@testable import PageCollection

extension DoubleTests {
    func testRoundDecimalPlaces_WhenNeedsFloor_ShouldRetunrsFloorDouble() {
        // Given
        var value: Double = 1.1234
        
        // When
        value.roundToDecimalPlaces(3)
        
        // Then
        let expected: Double = 1.123
        
        XCTAssertEqual(value, expected)
    }
    
    func testRoundDecimalPlaces_WhenNeedsCeil_ShouldRetunrsCeilDouble() {
        // Given
        var value: Double = 1.1235
        
        // When
        value.roundToDecimalPlaces(3)
        
        // Then
        let expected: Double = 1.124
        
        XCTAssertEqual(value, expected)
    }
}
