//
//  BubbleShape.swift
//  Tooltip
//
//  Created by wooyoung on 6/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI


/// 커스텀한 Bubble Shape를 정의합니다.
struct BubbleShape: Shape {
    var cornerRadius: CGFloat
    var arrowWidth: CGFloat
    var arrowHeight: CGFloat
    var arrowOffset: CGFloat

    var arrowDirection: ArrowDirection

    /// path(in:) 메서드에서 말풍선의 경로를 정의합니다.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 말풍선의 기본 사각형 부분
        let bubbleRect = rect
        
        // 사각형의 경로 정의
        path.addRoundedRect(in: bubbleRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        let arrowPositionX = bubbleRect.midX + arrowOffset
        
        switch arrowDirection {
        case .top:
            // 말풍선의 화살표 부분 (위쪽)
            let arrowStartX = arrowPositionX - arrowWidth / 2
            let arrowEndX = arrowPositionX + arrowWidth / 2
            let arrowTipX = arrowPositionX
            
            path.move(to: CGPoint(x: arrowStartX, y: bubbleRect.minY))
            path.addLine(to: CGPoint(x: arrowTipX, y: rect.minY - arrowHeight))
            path.addLine(to: CGPoint(x: arrowEndX, y: bubbleRect.minY))
            
        case .bottom:
            // 말풍선의 화살표 부분 (아래쪽)
            let arrowStartX = arrowPositionX - arrowWidth / 2
            let arrowEndX = arrowPositionX + arrowWidth / 2
            let arrowTipX = arrowPositionX
            
            path.move(to: CGPoint(x: arrowStartX, y: bubbleRect.maxY))
            path.addLine(to: CGPoint(x: arrowTipX, y: rect.maxY + arrowHeight))
            path.addLine(to: CGPoint(x: arrowEndX, y: bubbleRect.maxY))
        }
        
        return path
    }
}


#Preview("tail: bottom") {
    BubbleShape(
        cornerRadius: 20,
        arrowWidth: 20,
        arrowHeight: 20,
        arrowOffset: 0,
        arrowDirection: .bottom
    )
    .fill(Color.blue)
    .frame(width: 200, height: 100)
    .padding()
}

#Preview("tail: top") {
    /// 화살표가 위에 있는 Bubble Shape를 그립니다.
    BubbleShape(
        cornerRadius: 10,
        arrowWidth: 30,
        arrowHeight: 20,
        arrowOffset: 0,
        arrowDirection: .top
    )
    .fill(Color.blue)
    .frame(width: 200, height: 100)
    .padding()
}
