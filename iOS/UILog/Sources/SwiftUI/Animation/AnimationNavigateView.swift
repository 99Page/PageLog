//
//  AnimationNavigateView.swift
//  UILog
//
//  Created by 노우영 on 11/4/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI

struct AnimationNavigateView: View {
    var body: some View {
        List {
            NavigationLink("UIViewAnimation") {
                UIViewAnimationView()
            }
        }
    }
}

#Preview {
    AnimationNavigateView()
}
