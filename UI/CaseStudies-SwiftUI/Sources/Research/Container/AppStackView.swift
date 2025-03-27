//
//  AppStackView.swift
//  WWDC24
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct AppStackView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Container") {
                    NavigationLink("ForEach subviews API") {
                        ContainerView {
                            Text("ForEach")
                                .containerForegroundColor(.blue)
                            
                            Text("API!")
                                .containerForegroundColor(.cyan)
                        }
                    }
                    
                    NavigationLink("Section API") {
                        SectionContainerView {
                            Section {
                                Text("New section api")
                                Text("custom header")
                            }
                            
                            Section {
                                Text("Old section api")
                            } header: {
                                Text("Old header")
                            }
                            .containerForegroundColor(.green)

                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AppStackView()
}
