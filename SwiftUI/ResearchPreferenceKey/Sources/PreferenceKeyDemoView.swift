//
//  HomeView.swift
//  ReseachPreferenceKey
//
//  Created by wooyoung on 7/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// 여러개의 PreferenceKey를 동시에 사용했을 때의 동작을 알아보기 위한 뷰입니다.
struct PreferenceKeyDemoView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("PreferenceKeyInContainerView") {
                    PreferenceKeyInContainerView()
                }
                
                NavigationLink("EqualLevelPreferenceKeyView") {
                    EqualLevelPreferenceKeyView()
                }
            }
        }
    }
}

#Preview {
    PreferenceKeyDemoView()
}
