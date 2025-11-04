//
//  ZoomColorView.swift
//  UILog
//
//  Created by 노우영 on 11/4/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI

struct ZoomColorView: View {
    
    let identifiedColor: IdentifiedColor
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .aspectRatio(1.5, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .foregroundStyle(identifiedColor.color)
    }
}
