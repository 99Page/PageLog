//
//  Concurrency.swift
//  Tooltip
//
//  Created by 노우영 on 6/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// Task Group
/// Structrued Concurrency의 장점을 다 알아보기엔 부실한 예제인거 같다.
/// Task 밑에 계속 하위 Task를 추가해야 parent-child 구조를 보면서 확인할 수 있을거 같은데
/// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency#Task-Cancellation
/// 위 링크의 예제만으로는 불충분하다.
/// 추후에 보충하자. 
Task {
    await withTaskGroup(of: Int.self) { group in
        let values = [10, 20, 30, 40, 50, 60, 70]
        for value in values {
            group.addTask {
                return await processValue(value: value)
            }
            
        }
        
        
        for await returnedValue in group {
            print("\(returnedValue)")
        }
    }
    
}

RunLoop.current.run(mode: .default, before: .distantFuture)

func processValue(value: Int) async -> Int {
    try? await Task.sleep(for: .seconds(1))
    return value
}
