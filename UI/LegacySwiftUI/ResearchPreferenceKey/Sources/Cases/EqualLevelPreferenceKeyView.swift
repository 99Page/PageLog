//
//  ResearchEqualLevelPreferenceView.swift
//  ReseachPreferenceKey
//
//  Created by wooyoung on 7/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// 동일한 레벨을 가진 여러 뷰에서 Preference를 전달했을 때의 결과를 확인하기 위한 뷰입니다.
struct EqualLevelPreferenceKeyView: View {
    
    @State private var rootContainerBackgroundColor: Color = .black
    @State private var color: Color = .black
    
    var body: some View {
        VStack {
            VStack {
                
            }
            .frame(width: 100, height: 70)
            .preference(key: ColorPreferenceKey.self, value: .yellow)
            
            VStack {
                
            }
            .frame(width: 100, height: 70)
            .preference(key: ColorPreferenceKey.self, value: .green)
            
            VStack {
                
            }
            .frame(width: 100, height: 70)
            /// 순서상 마지막에 위치한 View의 Preference를 마지막에 전달합니다.
            /// 실행 로직은 `PreferenceKey`를 채택한 타입에 따라 달라집니다.
            /// 현재는 value를 nextValue로 설정해둬서
            /// 마지막에 전달된 blue가 rootContainerBackgroundColor 값이 됩니다. 
            .preference(key: ColorPreferenceKey.self, value: .blue)
            
        }
        .frame(width: 200, height: 300)
        .background(rootContainerBackgroundColor)
        .onPreferenceChange(ColorPreferenceKey.self) {
            rootContainerBackgroundColor = $0
        }
    }
}

#Preview {
    EqualLevelPreferenceKeyView()
}
