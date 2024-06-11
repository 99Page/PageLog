//
//  HomeView.swift
//  Tooltip
//
//  Created by 노우영 on 6/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(TooltipModel.self) var tooltipModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HeaderView()
                
                Spacer()
                
                Button {
                    tooltipModel.showTooltip(
                        of: .play,
                        xAnchor: ViewAnchor(source: \.midX, destination: \.midX),
                        targetY: \.minY
                    )
                } label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 80)
                        .foregroundStyle(Color.white)
                        .anchorPreference(key: DestinationAnchorPreferenceKey.self, value: .bounds) {
                            [AnchorType.play: $0]
                        }
                }
            }
            .background(
                Image(.bear)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all, edges: .vertical)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .overlay {
                GeometryReader { geometry in
                    tooltipModel.currentAnchor.map { anchor in
                        TooltipView(geometry: geometry, targetAnchor: anchor)
                    }
                }
            }
            .onPreferenceChange(DestinationAnchorPreferenceKey.self) { value in
                tooltipModel.anchors = value
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(TooltipModel())
}
