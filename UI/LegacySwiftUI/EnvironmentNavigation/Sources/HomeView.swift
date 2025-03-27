//
//  HomeView.swift
//  EnvironmentNavigation
//
//  Created by 노우영 on 9/7/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// Reference: https://www.youtube.com/watch?v=5pn75RCpVjY
///
/// EnvironmnetObject는 어디서 관리되는지 추적하기 어려운 문제가 있다.
/// 이 코드 베이스는 특히 함수와 값(Route)가 분리되어 있어 더 어렵다.
/// 그냥 네비게이션 기능을 하는 하나의 EnvironmentObject를 만드는게 더 나아보인다. 
struct HomeView: View {
    @State private var routes: [Route] = []
    @Environment(\.navigate) var navigate
    
    var body: some View {
        NavigationStack(path: $routes) {
            RedScreenNavigateButton()
                .navigationDestination(for: Route.self) {
                    $0.destination
                }
        }
        /// environment는 environmentObject와 달리 read-only
        .environment(\.navigate) { route in
            routes.append(route)
        }
    }
}

#Preview {
    HomeView()
}
