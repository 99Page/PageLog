//
//  MinHeapTests + insert.swift
//  HeapTests
//
//  Created by 노우영 on 8/18/24.
//  Copyright © 2024 Page. All rights reserved.
//

import XCTest
@testable import Heap

/// `peek`을 이용해서 테스트 결과를 검증합니다.
/// Heap은 부분적으로 정렬된 자료구조이기 때문에 전체 배열을 이용해 검증하기 불편합니다.
extension MinHeapTest {
    func testInsert_WhenInsertOneElement_ShouldPeekInsertedElement() {
        // Given
        let element = getRandomElement()
        
        // When
        minHeap.insert(element)
        
        // Then
        let firstElement = minHeap.peek()
        XCTAssertEqual(element, firstElement)
    }
    
    func testInsert_WhenInsertManyElements_ShouldPeekMinElement() {
        for _ in 0..<1000 {
            // Given
            minHeap = Heap<Int>.minHeap()
            var minValue: Int = .max
            
            // When
            for _ in 0..<1000 {
                let element = getRandomElement()
                minHeap.insert(element)
                minValue = min(element, minValue)
            }
            
            // Then
            let firstElement = minHeap.peek()
            XCTAssertEqual(minValue, firstElement, "예상값: \(minValue), 실제값: \(String(describing: firstElement))")
        }
    }
}
