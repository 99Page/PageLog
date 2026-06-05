//
//  KeepItemPositionView.swift
//  ApplePhotosEffect
//
//  Created by 노우영 on 8/9/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct KeepItemPositionView: View {
    
    @State private var isItemAdded: Bool = false
    @State private var position: Int?
    
    /// position을 걸어두면 아이템 추가되도 유지된다.
    /// 그런데 anchor 기준이 애매하다.
    /// 위치 동적으로 추적해서 UnitPoint도 계속 변경 해줘야할 거 같다.
    /// LazyVStack에서만 동작한다.
    var body: some View {
        ScrollView {
            LazyVStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.blue)
                    .frame(width: 300, height: 300)
                    .id(1)
                
//                /// 동일한 id를 가진 경우 최초 생성된 id값과 동일한 뷰가 생긴다.
//                /// 즉, 여기서는 Circle이 아닌 하단에 id 10을 가진 다른 RoundedRectangle이 생성된다.
//                /// SwiftUI에서 뷰를 바꾸면서 Scroll을 유지할 방법은 없는 것이다.
//                /// 동일한 뷰가 바뀌어야야 scroll position이 유지된다.
//                if isItemAdded {
//                    Circle()
//                        .fill(.green)
//                        .frame(width: 300, height: 300)
//                        .id(10)
//                }
//                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.orange)
                    .frame(width: 300, height: 300)
                    .id(2)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red)
                    .frame(width: 300, height: 300)
                    .id(3)
                
                if isItemAdded {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.black)
                            .frame(width: 300, height: 300)
                            .id(4 + index)
                    }
                }
                
//                if !isItemAdded {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.yellow)
                        .frame(width: 300, height: 300)
                        .id(10)
//                }
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.purple)
                    .frame(width: 300, height: 300)
                    .id(11)
      
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray)
                    .frame(width: 300, height: 300)
                    .id(12)
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $position, anchor: .bottom)
        .overlay {
            Button {
                isItemAdded.toggle()
            } label: {
                Text("toggle")
            }

        }
    }
}

#Preview {
    KeepItemPositionView()
}
