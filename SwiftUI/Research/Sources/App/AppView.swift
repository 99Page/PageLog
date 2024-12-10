//
//  AppView.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @State private var viewModel = AppViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.state.path) {
            List {
                Section {
                    VStack {
                        Button {
                            viewModel.symbolAnimationTapped()
                        } label: {
                            Text("Symbol Animation")
                        }

                    }
                } header: {
                    Text("Symbol")
                }
            }
            .navigationDestination(for: AppPath.self) { path in
                switch path {
                case .symbol:
                    SymbolAnimationView()
                }
            }
            .navigationTitle("Research")
        }
    }
}

#Preview {
    AppView()
}
