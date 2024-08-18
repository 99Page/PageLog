//
//  MinHeapTests + pop.swift
//  HeapTests
//
//  Created by 노우영 on 8/18/24.
//  Copyright © 2024 Page. All rights reserved.
//

import XCTest
@testable import Heap

extension MinHeapTest {
    func testPop_WhenPopRepeatCountIsElementCount_ShouldReturnsMaxValue() {
        let stressCount = 1000
        let elementCount = 1000
        
        for _ in 0..<stressCount {
            // Given
            minHeap = Heap<Int>.minHeap()
            var expected: Int = .min
            var actual: Int?
            
            for _ in 0..<elementCount {
                let element = getRandomElement()
                minHeap.insert(element)
                expected = max(element, expected)
            }
            
            // When
            for _ in 0..<elementCount {
                actual = minHeap.pop()
            }
            
            // Then
            XCTAssertEqual(actual, expected)
        }
    }
    
    func testPop_WhenPopCountIsMoreThanInsertionCount_ShouldReturnsNil() {
        
    }
}
