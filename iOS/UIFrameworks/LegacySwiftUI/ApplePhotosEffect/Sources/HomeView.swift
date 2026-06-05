//
//  HomeView.swift
//  ApplePhotosEffect
//
//  Created by 노우영 on 8/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

enum ItemType {
    case big
    case small
    
    var count: Int {
        switch self {
        case .big:
            1
        case .small:
            3
        }
    }
    
    var width: CGFloat {
        switch self {
        case .big:
            200
        case .small:
            300
        }
    }
    
    var padding: CGFloat {
        switch self {
        case .big:
            100
        case .small:
            50
        }
    }
    
    mutating func toggle() {
        switch self {
        case .big:
            self = .small
        case .small:
            self = .big
        }
    }
}

struct HomeView: View {
    
    @State var itemType: ItemType = .big
    @Namespace var namespace
    
    @ViewBuilder
    private func backgroundView() -> some View {
        if itemType == .big {
            Color.blue
                .matchedGeometryEffect(id: "capsule", in: namespace)
        }
    }
    
    
    @ViewBuilder
    private func backgroundView2() -> some View {
        if itemType == .small {
            Color.blue
                .matchedGeometryEffect(id: "capsule", in: namespace)
        }
    }
    
    @ViewBuilder
    private func mainBackground() -> some View {
        if itemType == .big {
            Color.clear
                .frame(width: itemType.width, height: itemType.width)
                .matchedGeometryEffect(id: "circle1", in: namespace)
                .matchedGeometryEffect(id: "circle2", in: namespace)
                .matchedGeometryEffect(id: "circle3", in: namespace)
        }
    }
    
    var body: some View {
        VStack {
            if itemType == .big {
                Image(.woman1)
                    .resizable()
                    .matchedGeometryEffect(id: "woman1", in: namespace)
                    .matchedGeometryEffect(id: "woman2", in: namespace)
                    .matchedGeometryEffect(id: "woman3", in: namespace)
                    .frame(width: 200, height: 200)
                    .transition(.scale(scale: 1))
                    .zIndex(1)
                
            } else {
                Image(.woman2)
                    .resizable()
                /// matchedGeometryEffect 위치 때문에 고생 좀 많이했다.
                /// 위치와 크기 변화만 주고 싶으면 modifier를 최상단에 붙이자.
                /// 헛짓 많이했다..
//                    .transition(.scale)
                    .matchedGeometryEffect(id: "woman2", in: namespace)
                    .frame(width: 300, height: 300)
                    .transition(.scale)
                    .zIndex(0)
                
                Image(.woman1)
                    .resizable()
//                    .transition(.scale)
                    .matchedGeometryEffect(id: "woman1", in: namespace)
                    .frame(width: 300, height: 300)
                    .transition(.scale(scale: 1))
                    .zIndex(1)
                
                Image(.woman3)
                    .resizable()
//                    .transition(.scale)
                    .matchedGeometryEffect(id: "woman3", in: namespace)
                    .frame(width: 300, height: 300)
                    .transition(.scale(scale: 1, anchor: .center))
                    .zIndex(0)
            }
        }
        .animation(.spring, value: itemType)
        .overlay {
            
            Button(action: {
                itemType.toggle()
            }, label: {
                Text("Button")
            })
            .foregroundStyle(.black)
            
        }
    }
}

#Preview {
    HomeView()
}
