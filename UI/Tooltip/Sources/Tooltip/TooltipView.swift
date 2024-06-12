//
//  TooltipView.swift
//  Tooltip
//
//  Created by 노우영 on 6/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct TooltipView: View {
    
    @Environment(TooltipModel.self) var tooltipModel
    
    @State var sourceTargetX: CGFloat = .zero
    @State var sourceTargetY: CGFloat = .zero
    @State var width: CGFloat = .zero
    
    private let arrowHeight: CGFloat = 6
    
    
    var body: some View {
        GeometryReader(content: { geometry in
            tooltipModel.currentAnchor.map { anchor in
                ZStack {
                    textView(arrowOffset: 0)
                        .anchorPreference(key: SourceAnchorPreferenceKey.self, value: .bounds) {
                            $0
                        }
                        .opacity(0)
                        .onPreferenceChange(SourceAnchorPreferenceKey.self, perform: { value in
                            if let value {
                                sourceTargetX = geometry[value][keyPath: tooltipModel.xAnchor.sourceAnchor]
                                sourceTargetY = geometry[value][keyPath: tooltipModel.yAnchor.sourceAnchor]
                                width = geometry[value].width
                            }
                        })
                    
                    textView(arrowOffset: arrowOffset(tooltipHalfWidth: width/2, destinationHalfWidth: geometry[anchor].width/2))
                        .offset(
                            x: geometry[anchor][keyPath: tooltipModel.xAnchor.destinationAnchor] - sourceTargetX,
                            y: geometry[anchor][keyPath: tooltipModel.yAnchor.destinationAnchor] - sourceTargetY
                        )
                        .offset(y: tooltipModel.tooltipYOffset)
                }
            }
        })
    }
    
    func arrowOffset(tooltipHalfWidth: CGFloat, destinationHalfWidth: CGFloat) -> CGFloat {
        switch tooltipModel.xAnchor.destinationAnchor {
        case \.minX:
            destinationHalfWidth - tooltipHalfWidth
        case \.midX:
            0
        case \.maxX:
            tooltipHalfWidth - destinationHalfWidth
        default:
            0
        }
    }
    
    private func textView(arrowOffset: CGFloat) -> some View {
        Text(tooltipModel.currentAnchorType?.text ?? "")
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(Color.black)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                BubbleShape(
                    cornerRadius: 6,
                    arrowWidth: 5,
                    arrowHeight: tooltipModel.arrowHeight,
                    arrowOffset: arrowOffset,
                    arrowDirection: tooltipModel.arrowDirection
                )
                    .fill(Color.white)
            )
    }
}
