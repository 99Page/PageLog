//
//  VanilaResearchView.swift
//  DragAndDrop
//
//  Created by wooyoung on 7/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ItemSwappableView: View {
    
    @State private var itemDropModel = ItemSwappableModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(itemDropModel.colorRectangleModels) { model in
                    ColorRectangleView(model: model)
                        .onDrag {
                            itemDropModel.draggedColorRectangleModel = model
                            return NSItemProvider(object: String("") as NSString)
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ItemSwappableView()
}
