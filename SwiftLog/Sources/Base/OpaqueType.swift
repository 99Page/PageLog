//
//  OpaqueType.swift
//  SwiftStudy
//
//  Created by 노우영 on 10/23/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct OpaqueType {
    protocol View: Equatable {
        associatedtype Body
        var body: Body { get }
    }
    
    struct Stack: View {
        typealias Body = Text
        
        var body: Body { Text() }
    }
    
    struct Text: View {
        typealias Body = Text
        
        var body: Body { Text() }
    }
    
    // associated type을 갖는 프로토콜을 반환할 수 있는 것이 Opaque type, 그 중 some.
    // some은 리버스 제너릭이라고 부른다.
    // 호출하는 쪽이 아닌 사용 하는 쪽에서 어떤 타입을 반환할지 지정해주고, 이 타입은 변경될 수 없다.
    // 호출하는 쪽에서 타입을 정한다는 점에서, Reverse Generic이라고도 표현한다.
    // 컴파일 타임에 반환할 타입을 고정한다.
    func runSome() -> some View {
        Stack() // 내부에서 반환할 타입을 고정. 다른 View 타입은 반환 불가능
    }
    
    // any는 뷰를 채택하는 모든 타입을 반환할 수 있다. 하지만 호출 후에 타입에 대한 정보가 지워져
    // 사용에 제약이 생긴다.
    func runAny(_ isText: Bool) -> any View {
        if isText { return Text() }
        return Stack()
    }
    
    func run() {
        let someView = runSome()
        let someView2 = runSome()
        
        // 컴파일러는 이 두가지가 같은 타입인 것을 알고 있다. 비교 연산 가능
        print(someView == someView2)
        
        let anyView = runAny(false)
        let anyView2 = runAny(true)
        
        // 컴파일러는 이 두 타입이 같은지 알 수 없다. 비교 연산이 불가능하다. 
//        print(anyView == anyView2)
    }
}
