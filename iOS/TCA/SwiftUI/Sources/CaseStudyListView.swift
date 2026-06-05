//
//  CaseStudyListView.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 6/26/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct CaseStudyListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("How To Use") {
                    NavigationLink("EnumState") {
                        EnumStateView(store: Store(initialState: EnumStateFeature.State.blue(.init(color: .blue)), reducer: {
                            EnumStateFeature()
                        }))
                    }
                }
            }
        }
    }
}

#Preview {
    CaseStudyListView()
}
