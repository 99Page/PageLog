//
//  DynamicMemberLookup.swift
//  Swift
//
//  Created by 노우영 on 8/28/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

/// dynamicMemberLookup은
/// 컴파일 시 없는 멤버에 대한 접근을 처리해주는 것이다.
@dynamicMemberLookup
struct Price {
    var priceByItem: [String: Int] = [:]

    subscript(dynamicMember key: String) -> Int? {
        return priceByItem[key]
    }
}

enum DynamicMemberLookupStudy {
    static func run() {
        let price = Price(priceByItem: ["apple": 100, "banana": 200])
        
        // Price 타입에는 apple이라는 멤버가 없다.
        // 존재하지 않는 멤버로 접근 하면 subscript(dynamicMember)로 연결된다.
        let applePrice = price.apple
        print("\(String(describing: applePrice))")
    }
}
