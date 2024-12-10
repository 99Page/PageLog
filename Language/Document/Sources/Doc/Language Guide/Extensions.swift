//
//  Extensions.swift
//  SwiftDocument
//
//  Created by 노우영 on 12/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// # Reference
/// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/extensions
///
/// class, struct, enum, protocol에 새로운 기능을 추가할 때 사용한다. 코드 원본에 접근할 수 없을 때 이용한다. (ex-import된 라이브러리)
/// extensions을 활용해 다음 것들을 할 수 있다.
///
/// * Computed property 추가
/// * Method 추가
/// * init 추가
/// * Subscript 추가
/// * Nested type 추가
/// * 기존 타입에 프로토콜 채택

// MARK: Computed properties

/// 아래처럼 Computed propety는 추가할 수 있지만
/// Stored property는 추가 할 수 없다.
/// Computed property는 함수에 더 가까우니가 그냥 함수만 추가할 수 있다고 알아두자.
private extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
}

private struct ComptedPropertyRunner {
    func run() {
        let marathon = 42.km + 195.m
        
        // Prints "A marathon is 42195.0 meters long
        print("A marathon is \(marathon) meters long")
    }
}

// MARK: Initializer

/// Class의 convenience initializer는 추가할 수 있지만 designated initializer는 추가할 수 없다.
/// 다른 module에서 initializer를 추가했으면 원본의 모듈에서 self로 호출할 수 없다.

private struct Size {
    var width = 0.0, height = 0.0
}

private struct Point {
    var x = 0.0, y = 0.0
}

/// `Rect` 타입은 모든 기본 값이 정의되어 있어 기본 이니셜라이저만 사용하거나
/// memberwise 이니셜라이저롤 통해 초기화 할 수 있다.
private struct Rect {
    var origin = Point()
    var size = Size()
}

/// 별도의 이니셜라이저를 추가하고 싶으면 아래처럼 추가해줄 수 있다.
/// extension에서 추가했기때문에 memberwise 이니셜라이저는 유지된다.
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

private struct InitializerRunner {
    func run() {
        let centerRect = Rect(
            center: Point(x: 4.0, y: 4.0),
            size: Size(width: 3.0, height: 3.0)
        )
        // centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)
    }
}

// MARK: Methods

/// instance method 추가하는 방법.
/// 아래 함수는 int 값만큼 task를 반복해서 실행시킨다.
private extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

/// enum, struct에서 instance를 변경시키는 함수를 정의하고 싶은 경우
/// mutating을 선언해야한다.
private extension Int {
    mutating func square() {
        self = self * self
    }
}

private struct MethodRunner {
    func run() {
        3.repetitions { print("Hello") }
        // Hello
        // Hello
        // Hello
        
        var someInt = 3
        someInt.square()
        // someInt is now 9
    }
}

// MARK: Subscripts

/// 아래 subscript는 int 값의 n번째 자리를 반환해준다.
/// * 123456789[0] -> 9
/// * 123456789[1] -> 8
private extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        
        return (self / decimalBase) % 10
    }
}

private struct SubscriptRunner {
    func run() {
        let _ = 746381295[0] // returns 5
        let _ = 746381295[1] // returns 9
        let _ = 746381295[2] // returns 2
        let _ = 746381295[8] // returns 7
    }
}

// MARK: Nested Types

/// `kind` 라는 새로운 computed property에서 내부에 정의한 `Kind` 타입을 사용하고 있다.
private extension Int {
    enum Kind {
        case negative, zero, positive
    }
    
    
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

private struct NestedTypeRunner {
    func run() {
        let numbers = [3, 19, -27, 0, -6, 0, 7]
        
        for number in numbers {
            switch number.kind {
            case .negative:
                print("- ", terminator: "")
            case .zero:
                print("0 ", terminator: "")
            case .positive:
                print("+ ", terminator: "")
            }
        }
        
        // Prints "+ + - 0 - 0 + "
    }
}

