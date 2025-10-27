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

struct MemorySpikeView: View {
    var body: some View {
        HStack {
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
