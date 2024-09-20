//
//  TestingArguments.swift
//  WWDC24Tests
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Testing

struct RandomValue {
    static var value: Bool = .random()
}

struct MarcoArguments {
    
    /// 각 테스트마다 태그를 지정해주면
    /// cmd + 6으로 볼 수 있는 좌측 인스펙터 창에서 태그별로 지정된 테스트들을
    /// 모아서 보거나 실행할 수
    ///
    /// 지정한 함수의 이름은
    /// cmd + 6으로 볼 수 있는 좌측 인스펙터 창에서 함수 이름을 대체해준다.
    ///
    /// 이 두가지는 @Suite 매크로에서도 동일하다
    @Test("Custom test", .tags(.customTag))
    func tag() async throws {
        
    }
    
    /// 기존에는 For문을 이용해서 stress test를 해줘야했는데
    /// 이제는 @Test 매크로 안에 원하는 값을 넣어서 테스트 가능하다.
    /// 이렇게 실행되는 테스트들은 전부 병렬로 실행되서 효율적이다.
    @Test(arguments: [1, 5, 3])
    func oddNumber(value: Int) {
        #expect(value % 2 == 1)
    }
    
    /// 일시적으로 동작을 막을 테스트는 .disabled를 이용할 수 있다.
    /// 어떤 문제로 테스트 시 크래시가 발생하거나 일시적으로 안하고 싶을 때 활용하자.
    /// .bugs를 함께 이용해서 관련 버그를 작성한 url이 어디깄는지 기록할 수 있다.
    @Test(.disabled("이 테스트는 실행되지 않습니다."), .bug("https://github.com/99Page", "My github profile"))
    func disableTest() {
        
    }
    
    /// 런타임에 실행조건이 바뀌고
    /// 그에 따라 선택적으로 테스트를 해야할 때는 enabled 사용
    @Test(.enabled(if: RandomValue.value))
    func enabledTest() {
        
    }
    
    /// 디바이스 버전 별로 테스트 실행하는 방법=
    @Test
    @available(iOS 17, *)
    func iOS17() async throws {
        
    }
}

extension Tag {
    /// https://developer.apple.com/documentation/testing/addingtags
    /// 커스텀 태크 추가하는 방법
    @Tag static var customTag: Tag
}
