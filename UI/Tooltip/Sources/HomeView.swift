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
                
                Button(action: {
                    tooltipModel.showTooltip(of: .play, targetX: \.midX, targetY: \.minY)
                }, label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 80)
                        .foregroundStyle(Color.white)
                        .anchorPreference(key: AnchorPreferenceKey.self, value: .bounds) {
                            [AnchorType.play: $0]
                        }
                })
            }
            .background(
                Image(.bear)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all, edges: .vertical)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .overlay {
                GeometryReader(content: { geometry in
                    tooltipModel.currentAnchor.map { anchor in
                        TooltipView()
                            .frame(alignment: .leading)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.blue)
//                            .offset(x: geometry[$0][keyPath: tooltipModel.targetX],
//                                    y: geometry[$0][keyPath: tooltipModel.targetY])
                    }
                })
            }
            .onPreferenceChange(AnchorPreferenceKey.self, perform: { value in
                tooltipModel.anchors = value
            })
        }
    }
}

#Preview {
    HomeView()
        .environment(TooltipModel())
}
