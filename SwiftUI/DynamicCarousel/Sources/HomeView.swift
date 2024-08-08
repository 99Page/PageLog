//
//  HomeView.swift
//  DynamicCarousel
//
//  Created by 노우영 on 8/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// Reference: https://www.youtube.com/watch?v=xU5z4IJpVg4
struct HomeView: View {
    @State private var activeId: UUID?
    
    let imageModels = ImageModel.images
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomCarousel(
                    selection: $activeId,
                    config: .init(),
                    data: imageModels
                ) { item in
                    Image(item.image)
                        .resizable()
                }
            }
            .navigationTitle("Dynamic Carousel")
            .frame(height: 200)
        }
    }
}

#Preview {
    HomeView()
}
