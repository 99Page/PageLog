//
//  HomeView.swift
//  Communication
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

enum Path: Hashable {
    case edit(CircleModel)
}

struct HomeViewModel {
    var path: [Path] = []
    var circleModel: [CircleModel] = [.circle]
}

struct HomeView: View {
    @State private var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            CircleListView(circles: vm.circleModel)
                .navigationDestination(for: Path.self) { path in
                    switch path {
                    case let .edit(circle):
                        CircleEditView(circle: circle)
                    }
                }
        }
    }
}

#Preview {
    HomeView()
}
