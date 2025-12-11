//
//  RerenderView.swift
//  UILog
//
//  Created by 노우영 on 12/11/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI
import PageKit

/// 뷰의 리렌더 방식을 확인하기 위한 뷰
///
/// <doc:View-update> 내용 참고
struct RerenderView: View {
    
    @State private var count = 0
    
    // 리렌더는 색상 변경으로 확인
    var body: some View {
        VStack {
            Button("Increase") {
                count += 1
            }
            
            // ChildView와 구현은 동일하지만,
            // Model data 변경에 영향을 받는다.
            // 아마 Primitive view들은 State 변경에 바로 영향을 받는거 같다.
            Rectangle()
                .foregroundStyle(Color(cgColor: UIColor.randomPastelColor.cgColor))
                .frame(width: 150, height: 150)
            
            // 의존중인 Model data가 변경되지 않으니
            // 리렌더 되지 않는다
            ChildView()
            
            Rectangle()
                .foregroundStyle(count % 2 == 0 ? .yellow : .red)
                .frame(width: 150, height: 150)
        }
    }
    
    struct ChildView: View {
        var body: some View {
            Rectangle()
                .foregroundStyle(Color(cgColor: UIColor.randomPastelColor.cgColor))
                .frame(width: 150, height: 150)
        }
    }
}

#Preview {
    RerenderView()
}
