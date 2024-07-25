//
//  ColorPreferenceKey.swift
//  ReseachPreferenceKey
//
//  Created by wooyoung on 7/25/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ColorPreferenceKey: PreferenceKey {
    static var defaultValue: Color = .gray
    
    static func reduce(value: inout Color, nextValue: () -> Color) {
        value = nextValue() 
    }
    
    typealias Value = Color
    
    
}
