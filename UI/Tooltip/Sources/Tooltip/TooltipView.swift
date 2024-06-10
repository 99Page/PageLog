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
    
    let targetAnchor: Anchor<CGRect>
    
    var body: some View {
        GeometryReader(content: { geometry in
            Text(tooltipModel.currentAnchorType?.text ?? "")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white)
                )
        })
    }
}
