//
//  UIKitPreviewProvider.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/15/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: () -> View

    init(_ builder: @escaping () -> View) {
        self.view = builder
    }

    func makeUIView(context: Context) -> View {
        return view()
    }

    func updateUIView(_ uiView: View, context: Context) {}
}

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: () -> ViewController

    init(_ builder: @escaping () -> ViewController) {
        self.viewController = builder
    }

    func makeUIViewController(context: Context) -> ViewController {
        return viewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
