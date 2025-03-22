//
//  File.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/20/24.
//

import SwiftUI
import ComposableArchitecture
import Dependencies
import GRDB

@main
struct StandupsApp: App {
    
    let model: FactModel
    
    init() {
        prepareDependencies {
            $0.defaultDatabase = DatabaseQueue.appDatabase
        }
        
        self.model = FactModel()
    }
    var body: some Scene {
        WindowGroup {
//            FactView(model: model)
            StackCaseView(store: Store(initialState: StackCaseFeature.State()) {
                StackCaseFeature()
            })
        }
    }
}


