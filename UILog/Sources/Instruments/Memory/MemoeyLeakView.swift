//
//  MemoeyLeakView.swift
//  UILog
//
//  Created by 노우영 on 11/4/25.
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
struct MemoryLeakView: View {
    
    // 모든 메모리 누수가 Graph debugger에서 감지되지 않습니다.
    // 따라서 반복문으로 여러개의 메모리 누수를 생성합니다. 
    let parents: [Parent] = (0..<1000).map { _ in
        Parent()
    }
    
    var body: some View {
        Button("Make Leak") {
            for parent in parents {
                parent.child = Child(parent: parent)
            }
        }
    }
    
    
    class Parent {
        var child: Child?
    }
    
    class Child {
        let parent: Parent
        
        init(parent: Parent) {
            self.parent = parent
        }
    }
    
}

