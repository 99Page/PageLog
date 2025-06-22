//
//  ColorView.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ColorView: View {
    
    let identifiedColor: IdentifiedColor
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .aspectRatio(1.5, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .foregroundStyle(identifiedColor.color)
    }
}

#Preview {
    ColorView(identifiedColor: IdentifiedColor(color: .blue))
}
