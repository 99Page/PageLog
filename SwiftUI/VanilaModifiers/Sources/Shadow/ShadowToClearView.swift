//
//  ShadowToClearView.swift
//  VanilaModifiers
//
//  Created by 노우영 on 8/14/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ShadowToClearView: View {
    var body: some View {
        VStack {
            /// 기본적으로 clear나 opacity가 0인 경우에는 shadow도 같이 사라진다.
            Color.clear
                .frame(width: 100, height: 100)
                .clipShape(viewShape())
                .shadow(color: .black, radius: 15, x: 0, y: 10)
            
            /// Color를 background 색상과 동일하게 하는 방법이 최선이다.
            /// 혹은 shadow를 붙일 background를 하나 만들고 붙여도 되는데,
            /// background의 모양은 뷰의 모양과 동일해야된다.
            /// 색상은 역시 background 색상과 동일해야한다.
            Color.clear
                .frame(width: 100, height: 100)
                .clipShape(viewShape())
                .background(
                    backgroundShadowView()
                )
        }
    }
    
    private func backgroundShadowView() -> some View {
        viewShape()
            .fill(.background)
            .shadow(color: .black, radius: 15, x: 0, y: 10)
    }
    
    private func viewShape() -> some Shape {
        RoundedRectangle(cornerRadius: 25)
    }
}

#Preview {
    ShadowToClearView()
}
