//
//  ZoomTransitionView.swift
//  UILog
//
//  Created by 노우영 on 11/4/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI

/// iOS 18 버전부터 사용가능한 Zoom transition을 활용해보는 뷰
///
/// # Reference
/// [UI 애니메이션 및 전환 효과 향상하기](https://developer.apple.com/kr/videos/play/wwdc2024/10145/)
struct ZoomTransitionView: View {
    
    let columns: [GridItem] = [.init(.flexible(minimum: 50)), .init(.flexible(minimum: 50))]
    
    @State var colors = IdentifiedColor.stubs
    @Namespace var namespace
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(colors) { color in
                    NavigationLink {
                        ZoomColorView(identifiedColor: color)
                            .zoomTransitionIfAvailable(sourceID: color.id, in: namespace)
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .aspectRatio(1.5, contentMode: .fit)
                            .foregroundStyle(color.color)
                    }
                    .matchedTransitionSourceIfAvailable(id: color.id, in: namespace)
                }
            }
            .padding(.horizontal, 10)
        }
        .navigationTitle("Zoom Transition API")
    }
}

private extension View {
    @ViewBuilder
    func zoomTransitionIfAvailable(sourceID: AnyHashable, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.navigationTransition(.zoom(sourceID: sourceID, in: namespace))
        } else {
            self
        }
    }
    
    
    @ViewBuilder
    func matchedTransitionSourceIfAvailable(id: AnyHashable, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }
}

#Preview {
    ZoomTransitionView()
}
