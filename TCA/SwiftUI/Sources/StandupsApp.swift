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
    var body: some Scene {
        WindowGroup {
            CaseStudyListView()
        }
    }
}


