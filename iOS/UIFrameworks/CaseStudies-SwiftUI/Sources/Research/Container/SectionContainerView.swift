//
//  SectionContainerView.swift
//  WWDC24
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct SectionContainerView<Content: View>: View {
    
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 80) {
            /// 상위 뷰에서부터 묶인 Section을 받아올 수 있다.
            ForEach(sections: content) { section in
                VStack {
                    /// 개별 뷰에 
                    let values = section.containerValues
                    let foregroundColor = values.foregroundColor
                    
                    if section.header.isEmpty {
                        Text("Custom header")
                    } else {
                        section.header
                    }
                    
                    section.content
                        .foregroundStyle(foregroundColor)
                }
            }
        }
    }
}

#Preview {
    SectionContainerView {
        Section {
            Text("Hello")
                .containerForegroundColor(.red)
            
            Text("World")
        }
        
        Section {
            Text("Hello")
            Text("World")
        } header: {
            Text("Input header")
        }
        .containerForegroundColor(.yellow)
    }
}
