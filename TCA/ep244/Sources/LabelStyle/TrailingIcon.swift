//
//  TrailingIcon.swift
//  TCA-244
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
