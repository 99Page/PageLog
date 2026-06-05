//
//  ToolbarView.swift
//  PageResearch
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// iOS 17 버전부터 사용 가능한 ``toolbar(removing:)`` API를 확인해본 뷰
///
/// ## Overview
///
/// 적용 가능한 대상이 다르다는 점을 제외하면, ``toolbarVisibility(:, for:)`` 와 크게 다른 점은 모르겠다.
///
/// ## Reference
/// [toolbar(removing:)](https://developer.apple.com/documentation/SwiftUI/View/toolbar(removing:))
struct ToolbarRemovingView: View {
    var body: some View {
        VStack {
            NavigationLink("zz") {
                Text("???")
                    .navigationTitle("Title2")
            }
        }
        .navigationTitle("Toolbar Removing")
        .toolbar(removing: .title) // 윗라인에서 적용한 title을 제거한다. 
    }
}

#Preview {
    NavigationStack {
        ToolbarRemovingView()
    }
}
