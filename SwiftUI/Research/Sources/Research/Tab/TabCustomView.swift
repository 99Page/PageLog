//
//  TabSectionView.swift
//  PageResearch
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

enum Tabs: String, Hashable, Equatable, Identifiable {
    case bell
    case heart
    
    var id: String { self.rawValue }
}

/// Tab의 기능들을 확인해본 뷰
///
/// ## Overview
///
/// 1. Tab section 개념
/// 2. Tab 커스텀
///
/// 탭 커스텀은 iPhone에서는 안된다. iPad, macOS에서만 가능.
/// Tab, TabSection에 id를 붙여주고,
/// TabView에 `.tabViewCustomization(:)` 붙여주면 된다.
///
/// ## Reference
/// [Enhancing your app’s content with tab navigation](https://developer.apple.com/documentation/swiftui/enhancing-your-app-content-with-tab-navigation)
struct TabCustomView: View {
    
    @AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization
    @State var selected: Tabs = .bell
    
    var body: some View {
        TabView(selection: $selected) {
            
            /// TabView 내부에서 탭 끼리의 계층을 구분하기 위해 TabSection을 사용한다.
            /// header는 iOS 버전에서는 확인할 수 없다.
            /// `.tabViewStyle(:)`과 함께, iPad에서 확인하자.
            TabSection {
                Tab("bell", systemImage: "bell", value: Tabs.bell) {
                    Text("bell")
                }
                .customizationID("section1.bell")
                
                Tab("heart", systemImage: "heart", value: Tabs.heart) {
                    Text("heart")
                }
                .customizationID("section1.heart")
                
            } header: {
                Text("heart1")
            }
            .customizationID("section1")
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($tabViewCustomization)
    }
}

#Preview {
    NavigationStack {
        TabCustomView()
    }
}
