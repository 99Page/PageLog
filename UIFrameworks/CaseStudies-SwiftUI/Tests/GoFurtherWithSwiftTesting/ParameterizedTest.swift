//
//  ParameterizedTest.swift
//  WWDC24Tests
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Testing

struct ParameterizedTest {
    /// argument로 전달할 수 있는건 최대 두개다. zip으로 묶으면 순서대로 전달된다. 
    @Test(arguments: zip([1, 2, 3], ["일", "이", "삼"]))
    func testParameter(int: Int, string: String) async throws {
        
    }

}
