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
    let cornerRadius: CGFloat
    
    func createPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        return path
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
    let shape = BubbleShape(cornerRadius: 15)
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    UIViewPreview {
        BubbleShapeView(shape: shape, frame: frame)
    }
    .frame(width: 100, height: 100)
}
