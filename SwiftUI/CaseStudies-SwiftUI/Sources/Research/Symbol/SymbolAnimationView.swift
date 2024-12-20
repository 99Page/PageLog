//
//  SymbolAnimationView.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// Symbol animation 기능
///
/// # Reference
/// [SF symbols 6의 새로운 기능](https://developer.apple.com/kr/videos/play/wwdc2024/10188/)
struct SymbolAnimationView: View {
    
    @State private var powerplugTapCount = 0
    @State private var bellTapCount = 0
    @State private var waveTapCount = 0
    @State private var moonTapCount = 0
    @State private var progressTapCount = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    powerplugTapCount += 1
                } label: {
                    Label("Breathe", systemImage: "mail.stack")
                }
                .symbolEffect(.breathe, value: powerplugTapCount)
                .font(.largeTitle)
                
                Button {
                    withAnimation { bellTapCount += 1 }
                } label: {
                    Label("Replace", systemImage: bellTapCount % 2 == 0 ? "bell.slash" : "bell")
                }
                .font(.largeTitle)
                .contentTransition(.symbolEffect(.replace))
                
                Button {
                    waveTapCount += 1
                } label: {
                    Label("Wiggle", systemImage: "wave.3.up")
                }
                .symbolEffect(.wiggle.right, value: waveTapCount)
                .font(.largeTitle)
                
                Button {
                    moonTapCount += 1
                } label: {
                    Label("Rotate", systemImage: "fan.desk")
                }
                .symbolEffect(.rotate, value: moonTapCount)
                .font(.largeTitle)

                Button {
                    progressTapCount += 1
                } label: {
                    Label("Variable color", systemImage: "progress.indicator")
                }
                .symbolEffect(.variableColor.reversing.hideInactiveLayers, value: progressTapCount)
                .font(.largeTitle)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .navigationTitle("Symbol animations")
        }
        .safeAreaPadding(.top, 20)
    }
}

#Preview {
    SymbolAnimationView()
}
