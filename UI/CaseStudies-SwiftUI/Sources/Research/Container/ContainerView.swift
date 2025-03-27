//
//  ContainerView.swift
//  WWDC24
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ContainerView<Content: View>: View {
    
    @ViewBuilder var content: Content
    
    var body: some View {
        List {
            /// iOS 18 버전 이후에서 사용 가능한 새로운 API 2가지
            /// 1. Group(subviews:)
            /// 2. ForEach(subviews:)
            ///
            /// content로 들어온 subview를 조회 가능하다.
            /// 기존에는 content에 들어온 뷰들을 개별 조회가 안됐다.
            Group(subviews: content) { subviews in
                ForEach(subviews: subviews) { subview in
                    let foregroundColor = subview.containerValues.foregroundColor
                    
                    subview
                    /// subviews 개수를 확인해서 뷰를 조절하는 방법
                        .font(.system(size: subviews.count < 5 ? 25 : 18))
                        .foregroundStyle(foregroundColor)
                }
            }
        }
    }
}

#Preview("Small font") {
    ContainerView {
        Text("Hello")
            .containerForegroundColor(.blue)
        
        Text("World")
            .containerForegroundColor(.yellow)
    }
}

#Preview("Big font") {
    ContainerView {
        Text("Hello")
        Text("World")
        Text("My ")
        Text("Name is ")
        Text("Noh woo young")
    }
}
