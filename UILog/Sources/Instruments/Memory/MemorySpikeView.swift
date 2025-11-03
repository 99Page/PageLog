//
//  MemorySpikeViewController.swift
//  UILog
//
//  Created by 노우영 on 10/29/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import SwiftUI
import PageKit

/// 메모리 사용량을 일시적으로 크게 증가시키는 상황을 재현한 뷰
///
/// ## Topics
///
/// ### Tutorial
/// - <doc:InstrumentMemory>
struct MemorySpikeView: View {
    var body: some View {
        VStack {
            Button("make spike") {
                for _ in 0..<100_000{
                    print("Now is \(Date.now)") // 가장 간단하게 확인할 수 있는 메모리 유지
                }
            }
            
            Button("avoid spike") {
                for _ in 0..<100_000{
                    autoreleasepool {
                        print("Now is \(Date.now)") // 가장 간단하게 확인할 수 있는 메모리 유지
                    }
                }
            }
        }
    }
}
