//
//  AddableView.swift
//  Communication
//
//  Created by 노우영 on 9/3/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

protocol AddableViewModel {
    mutating func onAddButtonTapped()
}

struct AddableView<Content: View, VM: AddableViewModel>: View {
    
    @Binding var vm: VM
    let content: () -> Content
    
    var body: some View {
        VStack {
            content()
            
            Spacer()
            
            Button(action: {
                vm.onAddButtonTapped()
            }, label: {
                Text("Add")
            })
        }
    }
}
