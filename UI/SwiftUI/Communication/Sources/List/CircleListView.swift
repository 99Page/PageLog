//
//  CircleListView.swift
//  Communication
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct CirclrListViewModel: AddableViewModel {
    var circles: [CircleModel]
    
    mutating func onAddButtonTapped() {
        circles.append(.circle)
    }
}

struct CircleListView: View {
    @State var vm: CirclrListViewModel
    
    init(circles: [CircleModel]) {
        self.vm = CirclrListViewModel(circles: circles)
    }
    
    var body: some View {
        AddableView(vm: $vm) {
            VStack {
                ForEach(vm.circles) { circle in
                    NavigationLink(value: Path.edit(circle)) {
                        CircleView(circleModel: circle)
                    }
                }
            }
        }
    }
}
