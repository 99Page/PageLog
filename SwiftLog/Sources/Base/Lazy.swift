//
//  Lazy.swift
//  SwiftStudy
//
//  Created by 노우영 on 9/30/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

// `lazy` 사용 시 선언 시점에 메모리에 올라가지 않고 그 값을 읽을 때 초기화시킨다.
// 두가지 상황에서 사용할 수 있다.
//
// 1. 초기화 비용이 크고, 초기화 시점에서 사용하지 않는 경우
// 2. 초기화 시점에서 self를 참조해야하는 경우
//
// # 문제점
//
// Thread-Safety 하지 않다. 여러 쓰레드에서 동시에 접근하면 여러번 초기화될 수도 있다.
// computedProperty로 선언을 하는 경우하는 경우에 메모리가 계속 유지된다.
class LazyUser {
    let name: String
    
    // 초기화 시점에 self를 참조하는 경우 사용
    lazy var description: String = {
        return "사용자 이름: \(self.name)"
    }()
    
    // computedProperty는 함수처럼 동작한다.
    // 기본적으로는 numbers를 호출할 때마다 매번 새로운 배열을 생성하고,
    // 메모리를 차지하지 않겠지만
    // lazy로 선언한 경우 호출 후 그 값이 계속 유지된다.
    lazy var numbers: [Int] = {
        return Array(0...1_000_000)
    }()
    
    init(name: String) {
        self.name = name
    }
}
