//
//  ImageModel.swift
//  DynamicCarousel
//
//  Created by 노우영 on 8/8/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ImageModel: Identifiable {
    let id = UUID()
    let image: ImageResource
}

extension ImageModel {
    static var images: [ImageModel] {
        [
            .init(image: .man1),
            .init(image: .woman1),
            .init(image: .manAndHorse),
            .init(image: .woman2),
            .init(image: .woman3)
        ]
    }
}
