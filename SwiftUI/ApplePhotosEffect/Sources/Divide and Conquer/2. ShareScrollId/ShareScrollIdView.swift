//
//  ShareScrollIdView.swift
//  ApplePhotosEffect
//
//  Created by 노우영 on 8/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ShareScrollIdView: View {
    
    @State private var isToggled: Bool = false
    @State private var id: Int?
    
    /// 서로 다른 스크롤뷰에서 id 공유 된다.
    /// 그런데 스크롤뷰 전환하면 스크롤 인디케이터 사라진다.
    /// 즉, 애플의 photos에서는 하나의 스크롤만 사용하고 있다. 
    var body: some View {
        VStack {
            
            Button {
                isToggled.toggle()
            } label: {
                Text("toggle")
            }

            Group {
                if isToggled {
                    ScrollView {
                        LazyVStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blue)
                                .frame(width: 300, height: 300)
                                .id(1)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.yellow)
                                .frame(width: 300, height: 300)
                                .id(2)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.orange)
                                .frame(width: 300, height: 300)
                                .id(3)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.green)
                                .frame(width: 300, height: 300)
                                .id(4)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.brown)
                                .frame(width: 300, height: 300)
                                .id(5)
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $id, anchor: .bottom)
                } else {
                    ScrollView {
                        LazyVStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blue)
                                .frame(width: 300, height: 300)
                                .id(1)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.yellow)
                                .frame(width: 300, height: 300)
                                .id(2)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.orange)
                                .frame(width: 300, height: 300)
                                .id(3)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.green)
                                .frame(width: 300, height: 300)
                                .id(4)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.brown)
                                .frame(width: 300, height: 300)
                                .id(5)
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $id, anchor: .bottom)
                }
            }
        }
        .onChange(of: id) { oldValue, newValue in
            debugPrint("newValue: \(id)")
        }
    }
}

#Preview {
    ShareScrollIdView()
}
