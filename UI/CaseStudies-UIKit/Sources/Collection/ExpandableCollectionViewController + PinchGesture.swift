//
//  ExpandableCollectionViewController + PinchGesture.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 4/28/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import Foundation

extension ExpandableCollectionViewController {
    
    /// 핀치 제스처에 따라 컬렉션 뷰를 scale로 변환
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            collectionState.zoomStartedIndexPath = indexPath(gesture)
        case .changed:
            if isZoominIn(gesture) {
                collectionState.decreaseTargetColumn()
                collectionState.updateTargetCenterColumn()
                
                let progress = zoomingInProgress(gesture)
                let scale = collectionState.zoomingInScale(progress)
                
                let scaleTransform = CGAffineTransform(scaleX: scale , y: scale)
                let translactionTransform = CGAffineTransform(translationX: collectionState.interpolatedTranslationXForZoomIn(progress), y: 0)
                collectionView.transform = scaleTransform.concatenating(translactionTransform)
            } else {
                collectionState.increaseTargetColumn()
                collectionState.updateTargetCenterColumn()
                
                let progress = zoomingOutProgress(gesture)
                let scale = collectionState.zoomingOutScale(progress)
                let translationX = collectionState.interpolatedTranslationXForZoomOut(progress)
                
                let scaleTransform = CGAffineTransform(scaleX: scale , y: scale)
                let translactionTransform = CGAffineTransform(translationX: translationX, y: 0)
                collectionView.transform = scaleTransform.concatenating(translactionTransform)
            }
            
        case .ended:
            collectionState.updateCurrentStates()
            
            /// 핀치 제스처 종료 시 scale 변환을 애니메이션으로 적용
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                let scaleTransform = CGAffineTransform(scaleX: collectionState.columnRatio, y: collectionState.columnRatio)
                let translationX = (cellWidth(numberOfColumns: collectionState.currentColumnCount) * CGFloat(collectionState.centColumnDif))
                let translactionTransform = CGAffineTransform(translationX: translationX, y: 0)
                
                collectionView.transform = scaleTransform.concatenating(translactionTransform)
                collectionState.lastGestureState.translationX = translationX
                collectionState.lastGestureState.scale = collectionState.columnRatio
            }
        case .cancelled:
            break
        default:
            break
        }
    }
    
    /// 핀치 제스처 진행률을 계산하여 반환
    /// - Parameter gesture: 핀치 제스처
    /// - Returns: 진행률 (0.0 ~ 1.0)
    private func zoomingInProgress(_ gesture: UIPinchGestureRecognizer) -> CGFloat {
        let minScale: CGFloat = 1.0
        let maxScale: CGFloat = 1.5
        return min((gesture.scale - minScale) / (maxScale - minScale), 1)
    }
    
    /// 핀치 제스처 축소(Zoom Out) 진행률을 계산하여 반환
    /// - Parameter gesture: 핀치 제스처
    /// - Returns: 진행률 (1.0: 최소 스케일, 0.0: 최대 스케일)
    private func zoomingOutProgress(_ gesture: UIPinchGestureRecognizer) -> CGFloat {
        let minScale: CGFloat = 0.6
        let maxScale: CGFloat = 1.0
        let progress = (gesture.scale - minScale) / (maxScale - minScale)
        return 1.0 - min(max(progress, 0), 1)
    }
    
    /// 핀치 제스처가 확대(Zoom In) 동작인지 여부 반환
    /// - Parameter gesture: 핀치 제스처
    /// - Returns: 확대 중이면 true, 아니면 false
    private func isZoominIn(_ gesture: UIPinchGestureRecognizer) -> Bool {
        gesture.scale > 1.0
    }
    
    /// 핀치 제스처가 발생한 위치의 컬렉션 뷰 인덱스 패스 반환
    /// - Parameter gesture: 핀치 제스처
    /// - Returns: 해당 위치의 IndexPath (없으면 nil)
    private func indexPath(_ gesture: UIPinchGestureRecognizer) -> IndexPath? {
        let location = gesture.location(in: collectionView)
        return collectionView.indexPathForItem(at: location)
    }
}
