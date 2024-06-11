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
    
    @State var sourceMinX: CGFloat = .zero
    
    let geometry: GeometryProxy
    let targetAnchor: Anchor<CGRect>
    
    var body: some View {
        Text(tooltipModel.currentAnchorType?.text ?? "")
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(Color.black)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
            )
            .anchorPreference(key: SourceAnchorPreferenceKey.self, value: .bounds) {
                $0
            }
            .onPreferenceChange(SourceAnchorPreferenceKey.self, perform: { value in
                if let value {
                    sourceMinX = geometry[value][keyPath: tooltipModel.xAnchor.source]
                    debugPrint("sourceMinX: \(sourceMinX)")
                }
            })
            .offset(x: geometry[targetAnchor][keyPath: tooltipModel.xAnchor.destination] - sourceMinX)
    }
}
