//
//  resultBuilder.swift
//  SwiftStudy
//
//  Created by 노우영 on 9/15/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

/// class, structure, enum에 사용하는 attribute
/// 복잡한 데이터 구조를 간단히 표현할 때 사용한다

@resultBuilder
struct ArrayBuilder {
    typealias Component = [Int] // Expression과 FinalResult 중간의 결과물에 사용할 타입
    typealias Expression = Int // resultBuilder의 input 타입
    
    static func buildBlock(_ components: Component...) -> Component {
        return Array(components.joined())
    }
    
    // 모든 ArrayBuilder에서 최초로 실행되는 함수.
    static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }
    
    static func buildEither(first component: ArrayBuilder.Component) -> ArrayBuilder.Component {
        return component
    }
    
    static func buildEither(second component: Component) -> Component {
          return component
      }
}

private struct Runner {
    func run() {
        // 배열의 형태가 아니라,
        // 숫자를 연속적으로 입력해서
        // Int 배열을 만들 수 있다.
        @ArrayBuilder var buildNumber: [Int] { 10 }
        var manual = ArrayBuilder.buildExpression(10)
        
        let someNumber = 19
        
        // 이 코드의 manual 전개 과정은 이렇다.
        @ArrayBuilder var builderConditional: [Int] {
            if someNumber < 12 {
                31
            } else if someNumber == 19 {
                32
            } else {
                33
            }
        }
        
        let manualEither: [Int]
        
        if someNumber < 12 {
            let partialResult = ArrayBuilder.buildExpression(31)
            let outerPartialResult = ArrayBuilder.buildEither(first: partialResult)
            manualEither = ArrayBuilder.buildEither(first: outerPartialResult)
        } else if someNumber == 19 {
            let partialResult = ArrayBuilder.buildExpression(32)
            let outerPartialResult = ArrayBuilder.buildEither(second: partialResult)
            manualEither = ArrayBuilder.buildEither(first: outerPartialResult)
        } else {
            let partialResult = ArrayBuilder.buildExpression(33)
            manualEither = ArrayBuilder.buildEither(second: partialResult)
        }
        
        print(manualEither)
    }
}
