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
                symbolSectionView()
                chartSectionView()
                animationSectionView()
            }
            .navigationDestination(for: AppPath.self) { path in
                switch path {
                case let .symbol(symbolPath):
                    switch symbolPath {
                    case .animation:
                        SymbolAnimationView()
                    }
                case let .swiftChart(path):
                    switch path {
                    case .basic:
                        SwiftChartBasicView()
                    case .linePlot:
                        LinePlotView()
                    }
                case let .animation(path):
                    switch path {
                    case .zoomTransition:
                        ZoomTransitionView()
                    }
                }
            }
            .navigationTitle("Research")
        }
    }
    
    private func animationSectionView() -> some View {
        Section {
            Button("Zoom transition") {
                viewModel.animationSectionTapped(.zoomTransition)
            }
        } header: {
            Text("Animations")
        }
    }
    
    private func chartSectionView() -> some View {
        Section {
            Button("ChartBasic") {
                viewModel.chartSectionTapped(.basic)
            }
            
            Button("LinePlot") {
                viewModel.chartSectionTapped(.linePlot)
            }

        } header: {
            Text("SwiftCharts")
        }
    }
    
    private func symbolSectionView() -> some View {
        Section {
            Button("Symbol Animation") {
                viewModel.symbolSectionTapped(.animation)
            }
        } header: {
            Text("Symbol")
        }
    }
}

#Preview {
    AppView()
}