//
//  MemoryPersistentGrowthView.swift
//  UILog
//
//  Created by 노우영 on 11/3/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SwiftUI

/// 메모리를 지속적으로 증가시키는 상황을 만드는 뷰
///
/// ## Topics
///
/// ### Tutorial
/// - <doc:InstrumentMemory>
struct MemoryPersistentGrowthView: View {
    var body: some View {
        VStack {
            Text("데이터가 캐싱됐습니다.")
            Text("뒤로가기 -> 현재 화면으로 이동을 반복하면 메모리가 증가됩니다.")
        }
        .onAppear {
            ImageStorage.shared.store(UIImage(resource: .audi)) // UIImage(resource: .audi).pngData는 약 26MB
        }
    }
    
    class ImageStorage {
        static let shared = ImageStorage()
        
        var storage: [Date: Data] = [:]
        
        func store(_ image: UIImage) {
            storage[.now] = image.pngData()!
        }
    }
}

#Preview {
    MemoryPersistentGrowthView()
}
