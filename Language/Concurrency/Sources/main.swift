//
//  Concurrency.swift
//
//  Created by 노우영 on 6/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

let task = Task {
    let result = await processTenValuesForRange()
    
    print("final result: \(result)")
}

/// 주어진 값에 따라 10개의 값을 처리하고 출력하는 함수
/// - Parameters:
///   - initialMultiplier: 초기 값에 곱해질 배수
func processTenValues(initialMultiplier: Int) async -> [Int]{
    debugPrint("process ten value start: \(initialMultiplier)")
    
    return await withTaskGroup(of: Int.self) { group in
        var result: [Int] = []
        
        for i in 0..<10 {
            let added = group.addTaskUnlessCancelled {
                return await processValue(value: (initialMultiplier * 10) + i)
            }
            
            guard added else {
                print("parent is canceled")
                break
            }
        }
        
        for await value in group {
            debugPrint(value)
            
            if Task.isCancelled {
                return result
            }
            
            result.append(value)
        }
        
        return result
    }
}

/// 1부터 4까지의 초기 배수를 사용하여 10개의 값을 처리하는 함수
func processTenValuesForRange() async -> [[Int]] {
    return await withTaskGroup(of: [Int].self) { group in
        var result: [[Int]] = [[]]
        
        for i in 1..<7 {
            group.addTask {
                /// 이 시점에서 실행을 시작한다.
                return await processTenValues(initialMultiplier: i)
            }
        }
        
        
        /// for문 없이 addTask만으로도 child task는 추가되고, 코드가 실행된다.
        /// 아래 문법은 실행 결과를 받아왔을 때 동작해주는 역할이다.
        for await value in group {
            print(value)
            result.append(value)
            
            if value.contains(20) || value.contains(10) || value.contains(30) {
                print("cancel")
                /// group.cancelAll로 이미 실행 중인 작업은 취소할 수 없다.
                group.cancelAll()
            }
        }
        
        return result
    }
}

/// 주어진 값을 처리하는 함수
/// - Parameters:
///   - value: 처리할 값
/// - Returns: 처리된 값
func processValue(value: Int) async -> Int {
    // 여기서 처리 로직을 구현
    let rand = Int.random(in: 1..<4)
    try? await Task.sleep(for: .seconds(rand))
    return value
}

RunLoop.current.run(mode: .default, before: .distantFuture)
