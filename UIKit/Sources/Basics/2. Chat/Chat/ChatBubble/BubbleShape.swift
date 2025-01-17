//
//  BubbleShape.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/17/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import SwiftUI

/// 채팅 버블 모양을 정의하는 타입
struct BubbleShape {
    enum Direction {
        case left
        case right
    }
    
    let cornerRadius: CGFloat
    let tailWidth: CGFloat
    let tailHeight: CGFloat
    let direction: Direction
    
    func createPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        let tailPath = createTailPath(in: rect)
        
        path.append(tailPath)

        return path
    }
    
    func createTailPath(in rect: CGRect) -> UIBezierPath {
        let tailPath = UIBezierPath()
        
        // 꼬리 시작점 (Rounded Rectangle 경계에서 시작)
        let tailStartPoint = CGPoint(x: rect.maxX - cornerRadius / 2, y: rect.minY + cornerRadius / 2)
        let tailMiddlePoint = CGPoint(x: rect.maxX + tailWidth, y: tailStartPoint.y)
        
        // 제어점: Start → Middle 커브
        let controlPoint = CGPoint(x: (tailStartPoint.x + tailMiddlePoint.x) / 2, y: tailStartPoint.y + tailWidth / 2) // 위쪽으로 약간 휘는 곡선

        // 꼬리 끝점
        let tailEndPoint = CGPoint(x: rect.maxX, y: rect.minY + cornerRadius + tailHeight)
        let endPointCurve = CGPoint(x: tailMiddlePoint.x - 5, y: tailEndPoint.y - 5)

        // 곡선 추가: Start → Middle
        tailPath.move(to: tailStartPoint)
        tailPath.addQuadCurve(to: tailMiddlePoint, controlPoint: controlPoint) // Start → Middle 커브
        tailPath.addQuadCurve(to: tailEndPoint, controlPoint: endPointCurve)

        return tailPath
    }
}


class BubbleShapeView: UIView {
    private let shape: BubbleShape
    
    init(shape: BubbleShape, frame: CGRect) {
        self.shape = shape
        super.init(frame: frame)
        backgroundColor = .clear // 투명 배경
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // BubbleShape 경로 생성
        let bubblePath = shape.createPath(in: rect)
        
        // Bubble 모양 그리기
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bubblePath.cgPath
        shapeLayer.fillColor = UIColor.systemGreen.cgColor
        
        // Layer 추가
        layer.sublayers?.forEach { $0.removeFromSuperlayer() } // 기존 Layer 제거
        layer.addSublayer(shapeLayer)
    }
}

#Preview {
    UIViewPreview {
        BubbleShapeView(
            shape: BubbleShape(cornerRadius: 20, tailWidth: 30, tailHeight: 15, direction: .right),
            frame: CGRect(x: 0, y: 0, width: 100, height: 200)
        )
    }
    .frame(width: 100, height: 100)
}
