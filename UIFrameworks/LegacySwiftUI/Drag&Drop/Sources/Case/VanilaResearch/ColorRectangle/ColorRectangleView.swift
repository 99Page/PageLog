//
//  ColorRectangleView.swift
//  DragAndDrop
//
//  Created by wooyoung on 7/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ColorRectangleView: View {
    
    let model: ColorRectangleModel
    
    var body: some View {
        Rectangle()
            .fill(model.color.opacity(0.3))
            .frame(height: 100)
            .onDrop(of: [.text], delegate: model)
    }
}
