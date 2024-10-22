//
//  TypeEase.swift
//  SwiftDocument
//
//  Created by 노우영 on 10/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

protocol Parent {
    associatedtype T: Child
    
    func execute(child: T)
}

protocol Child {
    
}

struct Parent1: Parent {
    func execute<C: Child>(child: C)  {
        
    }
    
    typealias T = Child1
    
}

struct Parent2: Parent {
    func execute(child: Child2) {
        
    }
    
    typealias T = Child2
}

struct Child1: Child {
    
}

struct Child2: Child {
    
}

// 타입 소거를 위한 TypeErasedParent 클래스
struct TypeErasedParent {
    private let _execute: (Child) -> Void

    init<P: Parent>(_ parent: P) {
        _execute = { child in
            guard let specificChild = child as? P.T else {
                fatalError("잘못된 Child 타입이 전달되었습니다.")
            }
            parent.execute(child: specificChild)
        }
    }

    func execute(child: Child) {
        _execute(child)
    }
}

func execute() {
    var parent = TypeErasedParent(Parent1())
    parent.execute(child: Child1())
    
    parent = TypeErasedParent(Parent2())
    parent.execute(child: Child1()) // 출력: Parent2 executed with Child2
}
