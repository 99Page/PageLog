//
//  ColorBindingView.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 2/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture

struct ColorState {
    var color: UIColor = .red
}

class ColorBindingView: UIView {
    @UIBinding var color: UIColor
    
    init(color: UIBinding<UIColor>) {
        self._color = color
        super.init(frame: .zero)
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateView() {
        observe { [weak self] in
            guard let self else { return }
            self.backgroundColor = color
        }
    }
}

#Preview {
    @Previewable @UIBinding var color = ColorState()

    UIViewPreview {
        ColorBindingView(color: $color.color)
    }
    .onTapGesture {
        debugPrint("tap")
        color.color = .green
    }
}
