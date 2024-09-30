//
//  Closures.swift
//  SwiftDocument
//
//  Created by 노우영 on 9/30/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

// Reference: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures

/**
 # Closure
 
 정의: 함께 실행될 이름 없는 함수
 다른 문법에서는 anonymous function, lambda 등으로 불린다.
 
 함수를 다른 곳에서 실행시키기 위해 값을 capture한다.
 */

/**
 # The sorted method
 */

struct SortTester {
    func test() {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        
        /// sorted에 들어갈 함수의 signature와 backward 함수의 signature가 가능하기때문에
        /// 아래처럼 이용할 수 있다.
        let reversedNames = names.sorted(by: backward)
    }
    
    func backward(_ s1: String, _ s2: String) -> Bool {
        s1 > s2
    }
}

/**
 # Closure Expression Syntax
 
 클로저 문법의 형태는 아래와 같다.
 
 { <parameters> -> <return type> in
 <state>
 }
 
 함수로 치면
 
 func <name> (<parameter>) -> <return type> {
   <state>
 }
 
 위 구조와 같다.
 */

struct ClosureSortedTester {
    func test() {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        
        /// 아래 clousre 형식은 backward 함수와 구조가 동일하다.
        /// 이름 없는 함수 = 클로저 임을 기억하자.
        let reversedNames = names.sorted { s1, s2 in
            s1 > s2
        }
    }
}

/**
 # Capturing Values & Closures Are Reference  Types
 */

struct CaputureTester {
    
    func test() {
        let incrementByTen = makeIncrementer(forIncrement: 10)
        
        incrementByTen() // 10
        incrementByTen() // 20. 내부에 runningTotal을 계속 capture하고 있어 위에서 실행된 함수와 동일한 값을 공유중.
        incrementByTen() // 30. closure는 reference type이기 때문에 값을 공유 중이다.
        
        let incrementBySeven = makeIncrementer(forIncrement: 7)
        incrementBySeven() // 7. 위에서 실행된 함수들과는 다른 값을 capture.
        
        let alsoIncrementByTen = incrementByTen
        alsoIncrementByTen() // 40. refrence type이니까 값을 복사하지 않고 공유한다.
    }
    
    func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        
        /// 외부 함수를 제외하고 아래 함수 내부만 봤을 때
        /// runningTotal, amount를 찾을 수 없는 값이다.
        /// 클로저를 사용하면 외부 context에 있는 값을 저장해서 사용한다.
        @discardableResult
        func incrementer() -> Int {
            runningTotal += amount
            return runningTotal
        }
        
        return incrementer
    }
}
