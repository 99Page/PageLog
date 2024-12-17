//
//  File.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/20/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct StandupsApp: App {
    var body: some Scene {
        WindowGroup {
            StackCaseView(store: Store(initialState: StackCaseFeature.State()) {
                StackCaseFeature()
            })
        }
    }
}


