//
//  TestReadability.swift
//  WWDC24Tests
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Testing

struct ErrorMaker {
    static func throwError() throws {
        throw CustomError.error1(value: 0)
    }
}


enum CustomError: Error {
    case error1(value: Int)
}

struct ReadbleArgument: CustomTestStringConvertible {
    var testDescription: String {
        "주어진 값은 \(value)입니다. Jump to report에서 확인할 수 있습니다."
    }
    
    let value: Int
    
    
}

struct TestReadability {
    /// 에러 반환을 테스트 하는 방법
    @Test
    func expectThrow() async throws {
        #expect(throws: CustomError.self) {
            try ErrorMaker.throwError()
        }
    }
    
    /// 에러 반환을 테스트 하는 방법.
    /// case에 있는 associated type 확인
    @Test
    func expectThrowErorCase() async throws {
        #expect {
            try ErrorMaker.throwError()
        } throws: { error in
            guard let error = error as? CustomError,
                  case let .error1(value) = error else {
                return false
            }
            
            return value == 0
        }
    }
    
    /// `.disable` trait은 당장 해결이 어려운 버그를 기록할 때 쓰고
    /// 이거는 바로 해결할 수 있는 문제나 원인 파악이 된 문제를 기록할 때 사용한다.
    @Test
    func knownIssue() async throws {
        withKnownIssue {
            #expect(throws: CustomError.self) {
                try ErrorMaker.throwError()
            }
        }
    }
    
    /// cmd + 6으로 볼 수 있는 테스트 결과 inspector 창에서 표시할 argument의 설명을 커스텀하기 위해서
    /// `CustomTestStringConvertible` 프로토콜을 사용할 수 있다.
    /// 테스트 결과에 우 클릭하고 Jump to report를 누를 수 있는데
    /// 여기에도 반영되는 값이다.
    /// 어떤 변수에 문제가 있는지 쉽게 확인 가능하다.
    ///
    /// 이렇게 argument를 전달해주는 걸 `Parameterizing test`라고 부른다.
    /// 1. 각 인수마다 테스트가 병렬로 실행되서 빠르고
    /// 2. 한개 인수에 대한 테스트가 실패해도 나머지는 전부 테스트한다. (for문은 한개 실패시 나머지 실행x)
    @Test(arguments: [ReadbleArgument(value: 1), ReadbleArgument(value: 3), ReadbleArgument(value: 5)])
    func testReportDescription(value: ReadbleArgument) async throws {
        #expect(value.value % 2 == 1)
    }
}
