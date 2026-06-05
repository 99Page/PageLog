//
//  ResearchPreferenceAddedContainerView.swift
//  ReseachPreferenceKey
//
//  Created by wooyoung on 7/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// PreferenceKey를 Container에서 사용한 경우의 동작을 확인하기 위한 뷰입니다.
struct PreferenceKeyInContainerView: View {
    
    @State private var outerContainerBackgroundColor: Color = .black
    let innerContainerBackgroundColor: Color = .green
    
    var body: some View {
        VStack {
            VStack {
                
            }
            /// 여러개의 preference가 전달되었고 Container 레벨이 다른 경우
            /// 더 하위의 container에서 전달한 preference는 무시됩니다.
            .preference(key: ColorPreferenceKey.self, value: .green)
            .frame(width: 100, height: 100)
            .background(innerContainerBackgroundColor)
        }
        .frame(width: 200, height: 200)
        /// Container에 preferenceKey를 붙여도 전달됩니다.
        .preference(key: ColorPreferenceKey.self, value: .red)
        .onPreferenceChange(ColorPreferenceKey.self) { value in
            outerContainerBackgroundColor = value
        }
        .background(outerContainerBackgroundColor)

    }
}

#Preview {
    PreferenceKeyInContainerView()
}
