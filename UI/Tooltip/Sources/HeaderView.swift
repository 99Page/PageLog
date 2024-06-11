//
//  HeaderView.swift
//  Tooltip
//
//  Created by 노우영 on 6/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    
    @Environment(TooltipModel.self) var tooltipModel
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                tooltipModel.showTooltip(
                    of: .chevron,
                    xAnchor: ViewAnchor(source: \.minX, destination: \.minX),
                    targetY: \.maxY
                )
            } label: {
                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(1.8, contentMode: .fit)
                    .frame(width: 23)
                    .font(.headline)
                    .foregroundStyle(Color.white)
            }
            .anchorPreference(key: DestinationAnchorPreferenceKey.self, value: .bounds) {
                [AnchorType.chevron: $0]
            }
            
            Spacer()
            
            Button {
                tooltipModel.showTooltip(
                    of: .title,
                    xAnchor: ViewAnchor(source: \.midX, destination: \.midX),
                    targetY: \.maxY
                )
            } label: {
                Text("Bear")
                    .font(.system(size: 23, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .anchorPreference(key: DestinationAnchorPreferenceKey.self, value: .bounds) {
                        [AnchorType.title: $0]
                    }
            }
            
            Spacer()
            
            Button {
                tooltipModel.showTooltip(
                    of: .ellipsis,
                    xAnchor: ViewAnchor(source: \.maxX, destination: \.maxX),
                    targetY: \.maxY
                )
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(4, contentMode: .fit)
                    .font(.headline)
                    .frame(width: 33)
                    .foregroundStyle(Color.white)
            }
            .anchorPreference(key: DestinationAnchorPreferenceKey.self, value: .bounds) {
                [AnchorType.ellipsis: $0]
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    HeaderView()
        .environment(TooltipModel())
}
