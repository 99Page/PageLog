//
//  HomeView.swift
//  DragAndDrop
//
//  Created by wooyoung on 7/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Vanila") {
                ItemSwappableView()
            }
        }
    }
}

#Preview {
    HomeView()
}
