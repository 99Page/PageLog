//
//  IdentifiedColor.swift
//  UILog
//
//  Created by 노우영 on 11/4/25.
//  Copyright © 2025 Page. All rights reserved.
//

import PageKit
import SwiftUI

struct IdentifiedColor: Identifiable, Hashable {
    let id = UUID()
    let color: Color
    
    static var stubs: [IdentifiedColor] {
        (0..<10).map { _ in
            IdentifiedColor(color: Color(cgColor: UIColor.randomPastelColor.cgColor))
        }
    }
}
