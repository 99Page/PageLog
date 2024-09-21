//
//  Sendable.swift
//  Concurrency
//
//  Created by 노우영 on 9/21/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// https://developer.apple.com/documentation/swift/sendable
///
/// Sendable이란?
/// data race 문제 없이 concurrent context에서 공유될 수 있는 값들
///
/// 동시성 문제를 위해서 actor를 사용했는데
/// actor는 기본적으로 Sendable 타입을 채택한다.
/// enum, struct, method 등도 Sendable을 채택할 수 있다. 
///
/// actor는 값의 쓰기, 읽기에 대해서 data race를 막아주는 역할을 하는데
/// Sendable은 전달되는 순간의 안정성을 확인하는거지 상태 관리를 해주지는 않는다.
/// Sendable이 채택되지 않는 타입이 동시성 영역에서 실행되면 컴파일러가 경고해준다.
/// 아래 코드가 예시


class NonSendableClass {
    var value: Int = 0
}

struct UserData: Sendable {
    let name: String
    let age: Int
    let nonSendable: NonSendableClass  // Sendable이 아님
}

func performConcurrentTask() async {
    let user = UserData(name: "Alice", age: 25, nonSendable: NonSendableClass())

    await Task {
        print("User data: \(user)")  // 이곳에서 컴파일러가 Sendable 체크
    }
}
