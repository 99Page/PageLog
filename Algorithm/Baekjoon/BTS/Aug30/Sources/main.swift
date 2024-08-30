//
//  main.swift
//  bronze.to.silver
//
//  Created by 노우영 on 8/30/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

let sequenceSize = Int(readLine()!)!
var sequence: [Int] = []

readSequence()
solve()

func solve() {
    var isPushed: [Bool] = Array(repeating: false, count: sequenceSize + 1)
    var targetElementIndex: Int = 0
    var stack: [Int] = []
    var pushCount: Int = 1
    
    var result: [Character] = []
    
    while targetElementIndex < sequenceSize {
        let targetElement = sequence[targetElementIndex]
        
        if isPushed[targetElement] {
            if targetElement == stack.last {
                stack.removeLast()
                result.append("-")
                targetElementIndex += 1
            } else {
                print("NO")
                return
            }
        } else {
            /// sequenceSize를 넘지 않는 pushCount는 들어가지 않는다고 어떻게 증명하지?
            /// 귀납법으로는 어려워보이고 귀류법 밖에 없을거 같네.
            if pushCount > sequenceSize {
                assert(false)
            }
            
            /// pushCount가 sequenceSize보다 크면 index out of range 문제가 생기겠네.
            /// 그러면 모순이 발생하는 거고
            /// 그렇지 않으면 pushCount는 적절한 수만 들어갔다고 볼 수 있겠다.
            isPushed[pushCount] = true
            stack.append(pushCount)
            pushCount += 1
            result.append("+")
        }
    }
    
    let output = result.map { String($0) }.joined(separator: "\n")
    print(output)
}

func readSequence() {
    (0..<sequenceSize).forEach { _ in
        let line = readLine()!
        let element = Int(line)!
        sequence.append(element)
    }
}
