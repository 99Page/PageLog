//
//  ColorRectangleView.swift
//  UILog
//
//  Created by 노우영 on 11/4/25.
//  Copyright © 2025 Page. All rights reserved.
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
        if #available(iOS 18.0, *) {
            context.animate {
                uiView.backgroundColor = UIColor(color)
            }
        } 
    }
}
