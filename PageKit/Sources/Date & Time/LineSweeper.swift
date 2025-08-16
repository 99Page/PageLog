//
//  LineSwipper.swift
//  PageKit
//
//  Created by 노우영 on 8/16/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct LineSweeper<T: Comparable> {
    var starts: [T]
    var ends: [T]
    
    
    /// 시작 시간, 종료 시간을 정렬하고 탐색하는 구간을 하나씩 옮기면서 확인합니다.
    mutating func sweep() -> Int {
        starts.sort()
        ends.sort()
        
        // [start, end) 규칙: 같은 시각이면 종료를 먼저 처리
        var startTimeIndex = 0, endTimeIndex = 0
        var currentOverlap = 0, maxOverlap = 0
        
        while startTimeIndex < starts.count && endTimeIndex < ends.count {
            
            // 시작 시간이 종료 시간보다 빠르다면 겹치는 구간
            if starts[startTimeIndex] < ends[endTimeIndex] {
                currentOverlap += 1
                startTimeIndex += 1
                maxOverlap = max(currentOverlap, maxOverlap)
            } else {
                // 시작 시간이 종료 시간과 동일하거나 늦는다면 겹치지 않은 구간
                // 종료 시간을 옮기는 중간 단계가 실제로는 겹치지 않는 구간일수도 있으나
                // 구하는 값은 '최대 겹치는 구간'이기 때문에 답에는 영향이 없음 
                currentOverlap -= 1
                endTimeIndex += 1
            }
        }
        
        return maxOverlap
    }
}
