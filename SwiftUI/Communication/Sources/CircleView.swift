//
//  CircleView.swift
//  Communication
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct CircleView: View {
    
    let circleModel: CircleModel
    
    var body: some View {
        Circle()
            .fill(circleModel.color)
            .frame(width: circleModel.size, height: circleModel.size)
    }
}

#Preview {
    CircleView(circleModel: .circle)
}
