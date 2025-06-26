//
//  ColorFeatures.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 6/26/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct ColorFeature {
    @ObservableState
    struct State {
        let color: Color
    }
    
    enum Action { }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

struct ColorView: View {
    
    let store: StoreOf<ColorFeature>
    
    var body: some View {
        Rectangle()
            .fill(store.color)
            .frame(width: 200, height: 200)
    }
}




