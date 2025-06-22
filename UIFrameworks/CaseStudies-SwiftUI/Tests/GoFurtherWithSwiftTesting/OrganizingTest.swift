//
//  OrganizingTest.swift
//  WWDC24Tests
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Testing

/// Suite로는 파일 한개 내부에서 테스트를 분리하고,
/// 여러 파일에서 테스트 분리하고 싶으면 Tag 사용
/// Tag는 `MeetSwiftTesting`에서 작성했으니 생략. 
@Suite("Food")
struct OrganizingTest {
    
    @Suite("Wheat")
    struct Wheat {
        @Test
        func eatNoodle() {
            
        }
    }
    
    @Suite("Rice")
    struct Rice {
        @Test func eatRiceNoodle() async throws {
            
        }
    }

}
