//
//  ColorUIVIew.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ColorRectangleView: UIViewRepresentable {
    @Binding var color: Color
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10 // Optional: Add rounded corners
        view.layer.masksToBounds = true
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.animate {
            uiView.backgroundColor = UIColor(color)
        }
    }
}
