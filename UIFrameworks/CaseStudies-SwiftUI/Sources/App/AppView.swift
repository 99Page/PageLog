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
                frameworkSectionView()
                toolbarSectionView()
                tabSectionView()
            }
            .navigationDestination(for: AppPath.self) { path in
                switch path {
                case let .symbol(symbolPath):
                    switch symbolPath {
                    case .animation:
                        if #available(iOS 18.0, *) {
                            SymbolAnimationView()
                        }
                    }
                case let .swiftChart(path):
                    switch path {
                    case .basic:
                        SwiftChartBasicView()
                    case .linePlot:
                        if #available(iOS 18.0, *) {
                            LinePlotView()
                        }
                    }
                case let .animation(path):
                    switch path {
                    case .zoomTransition:
                        if #available(iOS 18.0, *) {
                            ZoomTransitionView()
                        }
                    case .uiView:
                        if #available(iOS 18.0, *) {
                            UIViewAnimationView()
                        }
                    }
                case let .framework(path):
                    switch path {
                    case .translation:
                        if #available(iOS 18.0, *) {
                            TranslationView()
                        }
                    }
                case let .toolbar(path):
                    switch path {
                    case .toolbar:
                        if #available(iOS 18.0, *) {
                            ToolbarRemovingView()
                        }
                    }
                case let .tab(path):
                    switch path {
                    case .customTab:
                        if #available(iOS 18.0, *) {
                            TabCustomView()
                        }
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
            
            Button("UIView Animation") {
                viewModel.animationSectionTapped(.uiView)
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
    
    private func frameworkSectionView() -> some View {
        Section {
            Button("Translation") {
                viewModel.frameworkSectionTapped(.translation)
            }
        } header: {
            Text("Frameworks")
        }
    }
    
    private func toolbarSectionView() -> some View {
        Section {
            Button("Removing") {
                viewModel.toolbarSectionTapped(.toolbar)
            }
        } header: {
            Text("Toolbar")
        }
    }
    
    private func tabSectionView() -> some View {
        Section {
            Button("Tab custom") {
                viewModel.tabSectionTapped(.customTab)
            }
        } header: {
            Text("Tab")
        }
    }
}

@available(iOS 18.0, *)
#Preview {
    AppView()
}
