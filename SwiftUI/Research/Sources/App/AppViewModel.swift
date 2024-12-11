//
//  AppViewModel.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

@Observable
final class AppState {
    var path: [AppPath] = []
}

struct AppViewModel {
    var state = AppState()
    
    func symbolSectionTapped(_ symbolPath: SymbolPath) {
        state.path.append(.symbol(symbolPath))
    }
    
    func chartSectionTapped(_ chartPath: SwiftChartPath) {
        state.path.append(.swiftChart(chartPath))
    }
    
    func animationSectionTapped(_ animationPath: AnimationPath) {
        state.path.append(.animation(animationPath))
    }
    
    func frameworkSectionTapped(_ frameworkPath: FrameworkPath) {
        state.path.append(.framework(frameworkPath))
    }
}
