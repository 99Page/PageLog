//
//  RedScreenNavigateButton.swift
//  EnvironmentNavigation
//
//  Created by 노우영 on 9/7/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct RedScreenNavigateButton: View {
    
    @Environment(\.navigate) var navigate
    
    var body: some View {
        Button(action: {
            navigate(.color(.redScreen))
        }, label: {
            Text("go to red screen")
        })
    }
}

#Preview {
    RedScreenNavigateButton()
}
