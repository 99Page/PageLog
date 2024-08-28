//
//  MapTimeComplexityTests.swift
//  TimeComplexityTests
//
//  Created by 노우영 on 8/28/24.
//  Copyright © 2024 Page. All rights reserved.
//

import XCTest

final class MapTimeComplexityTests: XCTestCase {
    
    var sequence: [Int] = []
    
    override func setUp() async throws {
        (0..<1_000_000).forEach { count in
            sequence.append(count)
        }
    }
    
    override func tearDown() async throws {
        sequence = []
    }
    
    /// 0.12s 미만
    func testMapPerformance() throws {
        self.measure {
            /// map은 O(n)
            /// joined도 O(n).
            /// 최종적으로 2n이다.
            let result = sequence.map { "\($0)" }.joined(separator: " ")
        }
    }
    
    /// 0.13s 초과
    func testIteratePerformance() throws {
        self.measure {
            var result = ""
            /// 문자열의 append는 O(n)이다.
            /// 새로운 문자열을 만들어줄 메모리 공간을 할당하고
            /// 그 공간에 기존 문자열을 copy하는 과정이 필요하다.
            /// 따라서 n번 append하면 O(n^2) 이 필요하다.
            /// map + joined를 활용하면 새로운 문자열을 여러 번의 copy나 메모리 할당 없이 만들 수 있기 때문에 빠르다.
            for element in sequence {
                result.append("\(element) ")
            }
        }
    }

}
