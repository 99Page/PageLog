//
//  UIViewAnimationView.swift
//  UILog
//
//  Created by 노우영 on 11/4/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI

/// UIViewRepresentable에 애니메이션을 적용하는 방법
///
/// .animation modifier를 사용해도 UIViewRepresentable 내부에서는 효과가 적용되지 않는다.
/// iOS 18 버전부터는 2가지를 해주면서 애니메이션을 적용 할 수 있다.
///
/// 1. 바인딩 시 .animation() 호출
/// 2. updateUIView 내부에서 context.animate { } 사용
///
/// ## Reference
/// [UI 애니메이션 및 전환 효과 향상하기](https://developer.apple.com/kr/videos/play/wwdc2024/10145/)
struct UIViewAnimationView: View {
    
    @State var color: Color = .red
    
    
    var body: some View {
        VStack {
            ColorRectangleView(color: $color.animation())
            
            Button("Change color") {
                color = Color(cgColor: UIColor.randomPastelColor.cgColor)
            }
        }
        .animation(.spring, value: color)
        .onAppear {
            if #available(iOS 18.0, *) {
                
            } else {
                fatalError("iOS 18이상 버전에서만 확인 가능.")
            }
        }
    }
}

#Preview {
    UIViewAnimationView()
}
