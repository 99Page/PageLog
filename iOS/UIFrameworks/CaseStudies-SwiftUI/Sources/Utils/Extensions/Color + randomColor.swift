//
//  Color + randomColor.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

import SwiftUI

extension Color {
    /// A computed property that generates a random color.
    static var randomColor: Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
    
    /// Generates an array of random colors.
    ///
    /// - Parameter count: The number of random colors to generate.
    /// - Returns: An array of `Color` instances with random values.
    static func getRandomColors(_ count: Int) -> [Color] {
        return (0..<count).map { _ in Color.randomColor }
    }
}
