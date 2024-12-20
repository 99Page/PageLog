//
//  ChildView.swift
//  PageResearch
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// presentationSizing(_:) 기능을 알아보기 위한 뷰
///
/// ## Overview
///
/// .sheet, .fullScreenCover를 할 때 내부 content의 사이즈만큼만 뷰의 크기를 조절할 수 있다.
/// 그런데 iPhone에서는 적용안된다.
/// 확인 할거면 iPad로 확인하자. 
///
/// ## Reference
/// [presentationSizing(_:)](https://developer.apple.com/documentation/SwiftUI/View/presentationSizing(_:))

struct ChildPresentationSizingView: View {
    
    @State private var show = false
    var body: some View {
        Button("show") {
            show.toggle()
        }
        .sheet(isPresented: $show) {
            Text("Text")
                .presentationSizing(
                    .fitted
            )
        }
    }
}

#Preview {
    ChildPresentationSizingView()
}
