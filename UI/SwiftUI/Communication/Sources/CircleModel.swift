//
//  CircleModel.swift
//  Communication
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

@Observable
final class CircleModel: Identifiable, Hashable {
    let id = UUID()
    var size: CGFloat = 100
    var color: Color = .blue
    
    static var circle: CircleModel { CircleModel() }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(size)
        hasher.combine(color)
    }
    
    static func == (lhs: CircleModel, rhs: CircleModel) -> Bool {
        lhs.id == rhs.id
        && lhs.size == rhs.size
        && lhs.color == rhs.color
    }
}
