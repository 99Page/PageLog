//
//  HomeView.swift
//  Tooltip
//
//  Created by 노우영 on 6/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(TooltipModel.self) var tooltipModel
    @Environment(\.modelContext) private var context
    
    @State var tooltipRepository = TooltipRepository()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HeaderView()
                
                Spacer()
                
                Button {
                    tooltipModel.showTooltip(
                        of: .play,
                        xAnchor: .midXToMidX,
                        yAnchor: .maxYToMinY, 
                        arrowDirection: .bottom
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
                .onAppear {
                    if tooltipRepository.query(name: "play", context: context) {
                        tooltipModel.showTooltip(of: .play, xAnchor: .midXToMidX, yAnchor: .maxYToMinY, arrowDirection: .bottom)
                        let tooltipCheck = TooltipCheck(identifier: "play", isChecked: true)
                        tooltipRepository.insert(tooltipCheck, context: context)
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
                TooltipView()
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
