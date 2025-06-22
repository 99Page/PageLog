//
//  Test.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 9/20/24.
//

import Testing
@testable import WWDC24

/// Testing에서 알아야할 핵심 매크로는 4가지다
/// 1. @Test
/// 2. @Suite
/// 3. #expect
/// 4. #required
///
/// 이 파일에서는 위 4가지의 간단한 사용 예제를 작성했다.


/// # @Test & #expect
/// XCTTest에서는 test로 시작하는 함수가 테스트 대상이였는데 `Testing` 에서는
/// @Test 매크로가 선언된 함수가 테스트 대상이다.
/// @Test 붙이면 자동으로 실행 버튼이 생긴다.
/// 또한 XCTAssertEqual, XCTAssertNil 등이
/// 전부 #expect 매크로로 대체됐다.
@Test
func multiply_fail() {
    let actual = 3 * 4
    let expected = 11
    
    #expect(actual == expected)
}

@Test
func multiply_success() {
    let actual = 3 * 4
    let expected = 12
    
    #expect(actual == expected)
}

/// # #required
/// Test 함수 내부에서 실행 조건을 확인하기 위해 #required를 사용할 수 있다.
/// 이걸로 optional unwrapping도 가능하다.
@Test
func multiply_required() throws {
    let value = 3
    let multiplierOptional: Int? = 4
    
    let multiplier = try #require(multiplierOptional)
    try #require(value == 3)
    
    let actual = value * multiplier
    let expected = 12
    
    #expect(actual == expected)
}

/// # @Suite
/// 관련된 함수를 하나로 다 묶어줄 수 있다.
/// @Suite 옆에 실행 버튼이 생성되고 이걸 이용하면 타입 내부의 test 함수를 전체 실행할 수 있다.
@Suite
struct Multiplier {
    
    /// 내부에 있는 값은 각 테스트 함수 실행 마다 초기화된다.
    /// 이전 XCTTest에서는 setUp, tearDown으로 이 값들을 조절해야했고
    /// 일부 ! 값을 피할 수 없었는데 여기서 편리해졌다.
    var value = 3
    
    @Test
    mutating func multiply_fail() {
        let actual = value * 4
        let expected = 11
        
        #expect(actual == expected)
        value += 1
    }

    @Test
    mutating func multiply_success() {
        let actual = value * 4
        let expected = 12
        
        #expect(actual == expected)
        value += 1
    }
}
