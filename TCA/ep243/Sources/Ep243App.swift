//
//  Ep243App.swift
//  TCA#243
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 VauDium. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@main
struct Ep243App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: CounterFeature.State(), reducer: {
                CounterFeature()
            }))
        }
    }
}

