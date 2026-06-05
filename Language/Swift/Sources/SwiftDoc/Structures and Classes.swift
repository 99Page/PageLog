//
//  Structures and Classes.swift
//  SwiftDocument
//
//  Created by 노우영 on 9/30/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// Reference: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures

/**
 # Comparing Structures and Classes
 
 클래스와 구조체는 비슷한 기능을하지만 클래스는 구조체에 비해 부가적인 몇가지 기능이 더 있다.
 
 1. 상속
 2. 타입 캐스팅
 3. Deinit
 4. 참조 카운팅
 
 우선적으로는 구조체를 고려하고 위 4가지 기능이 필요한 경우에 클래스를 사용하자.
 (상속이 필요한 경우도 우선은 프로토콜을 먼저 고민해보자)
 */

/**
 # Memeberwise Initializer for Structure Type
 
 구조체는 내부 프로퍼티를 초기화할 수 있는 기본 이니셜라이저를 제공해준다.
 반면에 클래스는 항상 initializer를 선언해야한다
 */

struct MacBook {
    let price: Int
    let name: String
}

class iPhone {
    let price: Int
    let name: String
    
    init(price: Int, name: String) {
        self.price = price
        self.name = name
    }
}

struct MemberwiseTester {
    func test() {
        let _ = MacBook(price: 1000, name: "MacBook Air")
        let _ = iPhone(price: 500, name: "iPhone 14")
    }
}

/**
 # Strcutes and Enumerations Are Value Types
 
 struct, enum은 value type이고 함수의 인자로 넘어가면 그 값을 복사해서 사용한다.
 Swift에서 제공해주는 Int, String, Double 같은 모든 타입은 모두 value type이다.
 
 Collection(배열, Dictionary 등)은 copy 시에 모든 값을 복제하지 않고 우선은 같은 메모리를 공유한다.
 Collection에 write가 실행되면(값이 변경되면) 그 때 복제한다.
 */

/**
 # Identity Operators
 
 class는 여러 변수로부터 참조될 수 있다.
 서로 다른 두 변수가 같은 class instance를 참조하는지 확인하기 위해 Identity operator를 사용한다.
 */

struct IdentityOperatorTester {
    func test() {
        let myiPhone = iPhone(price: 1000, name: "iPhone 14")
        let newiPhone = myiPhone
        
        print(myiPhone === newiPhone) /// 같은 객체를 참조하고 있으니 true
        
        let oldiPhone = iPhone(price: 2000, name: "iPhone 12")
        
        print(myiPhone === oldiPhone) /// 다른 객체기때문에 false
    }
}
