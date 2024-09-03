//
//  CircleEditView.swift
//  Communication
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct CircleEditViewModel {
    let circle: CircleModel
    
    func onCircleTapped() {
        let colorCandidates: [Color] = [.blue, .orange, .red, .green, .purple]
        let color = colorCandidates.randomElement() ?? .blue
        circle.color = color
    }
}

struct CircleEditView: View {
    @State private var vm: CircleEditViewModel
    
    init(circle: CircleModel) {
        self.vm = CircleEditViewModel(circle: circle)
    }
    
    var body: some View {
        Button(action: {
            vm.onCircleTapped()
        }, label: {
            CircleView(circleModel: vm.circle)
        })
    }
}

