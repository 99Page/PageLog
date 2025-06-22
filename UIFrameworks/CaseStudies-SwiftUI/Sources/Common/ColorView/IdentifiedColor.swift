//
//  IdentifiedColor.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct IdentifiedColor: Identifiable, Hashable {
    let id = UUID()
    let color: Color
    
    static var stubs: [IdentifiedColor] {
        Color.getRandomColors(10).map { IdentifiedColor(color: $0) }
    }
}
