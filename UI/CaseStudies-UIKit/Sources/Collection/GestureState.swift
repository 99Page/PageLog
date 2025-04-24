//
//  GestureState.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 4/28/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct CollectionState {
    var cachedWidth: CGFloat?
    
    var maxColumnCount = 7
    
    private(set) var currentColumnCount: Int
    var currentCenterColumn: Int
    
    private(set) var targetColumnCount: Int
    private(set) var targetCenterRow: Int
    private(set) var targetCenterColumn: Int
    
    var zoomStartedIndexPath: IndexPath?
    
    let centerColumn: Int
    
    var lastGestureState = GestureState()
    
    var columnRatio: Double {
        Double(maxColumnCount) / Double(targetColumnCount)
    }
    
    var targetCentColumnDif: Int {
        centerColumn - targetCenterColumn
    }
    
    var centColumnDif: Int {
        centerColumn - currentCenterColumn
    }
    
    init() {
        self.currentColumnCount = maxColumnCount
        
        self.centerColumn = (maxColumnCount / 2)
        
        self.currentCenterColumn = centerColumn
        self.targetColumnCount = currentColumnCount
        self.targetCenterColumn = centerColumn
        self.targetCenterRow = centerColumn
    }

    mutating func updateTargetCenterColumn() {
        guard let zoomStartedIndexPath else { return }
        targetCenterColumn = zoomStartedIndexPath.row % maxColumnCount
        
        let threshold = targetColumnCount / 2
        
        targetCenterColumn = max(targetCenterColumn, threshold)
        targetCenterColumn = min(targetCenterColumn, maxColumnCount - threshold - 1)
    }
    
    mutating func updateCenterColumn(_ indexPath: IndexPath?) {
        guard let indexPath else { return }
        currentCenterColumn = indexPath.row % maxColumnCount
        
        let threshold = currentColumnCount / 2
        
        currentCenterColumn = max(currentCenterColumn, threshold)
        currentCenterColumn = min(currentCenterColumn, maxColumnCount - threshold - 1)
    }
    
    /// 현재 제스처 스케일을 기준으로, 목표 스케일까지 진행률(progress)에 맞춰 보간한 스케일 반환
    /// - Parameter progress: 제스처 진행률 (0.0 ~ 1.0)
    /// - Returns: 보간된 스케일 값
    func zoomingInScale(_ progress: CGFloat) -> CGFloat {
        var result = lastGestureState.scale
        let targetScale = CGFloat(maxColumnCount) / CGFloat(targetColumnCount)
        let diff = targetScale - result
        
        result = result + diff * progress
        return result
    }
    
    /// 현재 제스처 스케일을 기준으로, 목표 스케일까지 진행률(progress)에 맞춰 보간한 축소 스케일 반환
    /// - Parameter progress: 제스처 진행률 (0.0 ~ 1.0)
    /// - Returns: 보간된 축소 스케일 값
    func zoomingOutScale(_ progress: CGFloat) -> CGFloat {
        var result = lastGestureState.scale
        let targetScale = CGFloat(maxColumnCount) / CGFloat(targetColumnCount)
        let diff = targetScale - result
        
        result = result - diff * -progress
        return result
    }
    
    /// 현재 제스처 이동값을 기준으로, 목표 이동값까지 진행률(progress)에 맞춰 보간한 X축 이동값 반환
    /// - Parameter progress: 제스처 진행률 (0.0 ~ 1.0)
    /// - Returns: 보간된 이동 거리 값
    func interpolatedTranslationXForZoomIn(_ progress: CGFloat) -> CGFloat {
        var result = lastGestureState.translationX
        
        let targetTranslationX = targetCellWidth() * CGFloat(targetCentColumnDif)
        let diff = targetTranslationX - result
        result = result + diff * progress
        return result
    }
    
    /// 현재 제스처 이동값을 기준으로, 목표 이동값까지 진행률(progress)에 맞춰 보간한 X축 이동값 반환
    /// - Parameter progress: 제스처 진행률 (0.0 ~ 1.0)
    /// - Returns: 보간된 이동 거리 값
    func interpolatedTranslationXForZoomOut(_ progress: CGFloat) -> CGFloat {
        var result = lastGestureState.translationX
        
        let targetTranslationX = targetCellWidth() * CGFloat(targetCentColumnDif)
        let diff = targetTranslationX - result
        result = result + diff * progress
        return result
    }
    
    
    mutating func updateCurrentStates() {
        currentCenterColumn = targetCenterColumn
        currentColumnCount = targetColumnCount
    }
    
    func targetCellWidth() -> CGFloat {
        cellWidth(numberOfColumns: targetColumnCount)
    }
    
    
    func currentCellWidth() -> CGFloat {
        cellWidth(numberOfColumns: currentColumnCount)
    }
    
    mutating func increaseTargetColumn() {
        guard currentColumnCount < maxColumnCount else { return }
        targetColumnCount = currentColumnCount + 2
    }
    
    mutating func decreaseTargetColumn() {
        guard currentColumnCount > 1 else { return }
        targetColumnCount = currentColumnCount - 2
    }
    
    mutating func updateTargetColumn(_ isZoomingIn: Bool) {
        if isZoomingIn {
            guard currentColumnCount < 5 else { return }
            targetColumnCount = currentColumnCount + 2
        } else {
            guard currentCenterColumn > 1 else { return }
            targetColumnCount = currentCenterColumn - 2
        }
    }
    
    func cellWidth(numberOfColumns: Int) -> CGFloat {
        guard let cachedWidth = cachedWidth else { return 0 }
        let width = cachedWidth / CGFloat(numberOfColumns)
        return width
    }
    
    func cellWidth(scale: CGFloat) -> CGFloat {
        guard let cachedWidth = cachedWidth else { return 0 }
        let width = cachedWidth * scale
        return width
    }

}

struct GestureState {
    var translationX: CGFloat = .zero
    var scale: CGFloat = 1
}
