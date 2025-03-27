//
//  HomeView.swift
//  VanilaModifiers
//
//  Created by 노우영 on 8/14/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Shadow") {
                    VStack {
                        NavigationLink {
                            ShadowToClearView()
                        } label: {
                            Text("ShadowToClear")
                        }

                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
