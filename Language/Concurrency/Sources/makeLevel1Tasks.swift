//
//  check3DepthTask.swift
//  Concurrency
//
//  Created by 노우영 on 6/30/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

/// 아래 같은 Structured task를 만들고, 확인하는 것이 목표.
///                 [1. Task] Lv0
///                     |
///     ----------------------------------------
///     |                                                                                       |
///  [2. Task]                                                                         [3. Task] Lv1
///     |                                                                                       |
///     ----------------------------                                                ...
///     |                                      |
///  [Task]                              [Task] Lv2


/// 최상위 Task의 하위 child tasks를 만들어주는 함수.
/// - Returns: [[Int]] 형태의 2차원 배열을 반환
func makeLevel1Tasks() async -> [[Int]] {
    return await withTaskGroup(of: [Int].self) { group in
        var result: [[Int]] = [[]]
        
        for i in 1..<7 {
            group.addTask {
                /// 이 시점에서 makeLevel2Tasks를 실행한다.
                return await makeLevel2Tasks(initialMultiplier: i)
            }
        }
        
        /// child task의 실행 결과를 받아와서 처리한다.
        for await value in group {
            print(value)
            result.append(value)
            
            if value.contains(20) || value.contains(10) || value.contains(30) {
                print("cancel")
                /// group.cancelAll로 이미 실행 중인 작업은 취소할 수 없다.
                /// cancel된 상태를 이용해 Child task에서 처리해야 한다.
                group.cancelAll()
            }
        }
        
        return result
    }
}

/// Level2의 child task들을 추가하는 함수. 주어진 값을 이용해서 10개의 값을 처리한다.
/// - Parameters:
///   - initialMultiplier: 초기 값에 곱해질 배수
/// - Returns: [Int] 형태의 배열을 반환
private func makeLevel2Tasks(initialMultiplier: Int) async -> [Int] {
    print("process ten value start: \(initialMultiplier)")
    
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
            print(value)
            
            if Task.isCancelled {
                return result
            }
            
            result.append(value)
        }
        
        return result
    }
}

/// 주어진 랜덤한 시간 이후에 반환하는 함수. 
/// - Parameters:
///   - value: 처리할 값
/// - Returns: 처리된 값
private func processValue(value: Int) async -> Int {
    /// 여기서 처리 로직을 구현
    let rand = Int.random(in: 1..<4)
    try? await Task.sleep(for: .seconds(rand))
    return value
}
