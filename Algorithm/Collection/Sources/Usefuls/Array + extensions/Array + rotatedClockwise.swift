//
//  Array + rotatedCounterClockwise.swift
//  PageCollection
//
//  Created by 노우영 on 10/2/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    
    /// 2차원 배열을 반시계 방향으로 90도 회전한 배열을 반환
    var rotatedCounterClockwise: [[Element.Element]] {
        guard let gridSize = self.first?.count else { return [] }
        
        var rotatedMap: [[Element.Element]] = []
        
        for col in (0..<gridSize).reversed() {
            var rotatedRow: [Element.Element] = []
            
            for row in (0..<self.count) {
                rotatedRow.append(self[row][col])
            }
            
            rotatedMap.append(rotatedRow)
        }
        
        return rotatedMap
    }
    
    /// 2차원 배열을 시계 방향으로 90도 회전한 배열을 반환
    var rotatedClockwise: [[Element.Element]] {
        guard let gridSize = self.first?.count else { return [] }
        
        var rotatedMap: [[Element.Element]] = []
        
        for col in 0..<gridSize {
            var rotatedRow: [Element.Element] = []
            
            for row in (0..<self.count).reversed() {
                rotatedRow.append(self[row][col])
            }
            
            rotatedMap.append(rotatedRow)
        }
        
        return rotatedMap
    }
}
