//
//  ThemePicker.swift
//  TCA-244
//
//  Created by 노우영 on 8/21/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ThemePicker: View {
    @Binding var selection: Theme
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    .tag(theme)
            }
        }
        .pickerStyle(.navigationLink)
    }
}


#Preview {
    ThemePicker(selection: .constant(.bubblegum))
}
