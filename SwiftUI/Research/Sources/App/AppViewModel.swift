//
//  AppViewModel.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

enum AppPath {
    case symbol
}

@Observable
final class AppState {
    var path: [AppPath] = []
}

struct AppViewModel {
    var state = AppState()
    
    func symbolAnimationTapped() {
        state.path.append(.symbol)
    }
}
