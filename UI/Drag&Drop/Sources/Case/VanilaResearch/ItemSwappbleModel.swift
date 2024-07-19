//
//  ItemSwappbleModel.swift
//  DragAndDrop
//
//  Created by wooyoung on 7/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

@Observable
final class ItemSwappableModel: ColorRectangleDropDelegate {
    var colorRectangleModels: [ColorRectangleModel]
    
    var draggedColorRectangleModel: ColorRectangleModel?
    var enteredColorRectangleModel: ColorRectangleModel?
    
    init() {
        self.colorRectangleModels = []
        
        self.colorRectangleModels = [
            ColorRectangleModel(color: .red, delegate: self),
            ColorRectangleModel(color: .blue, delegate: self),
            ColorRectangleModel(color: .yellow, delegate: self),
            ColorRectangleModel(color: .green, delegate: self),
            ColorRectangleModel(color: .purple, delegate: self),
            ColorRectangleModel(color: .orange, delegate: self)
        ]
    }
    
    func setEnteredColorRectangleModel(_ model: ColorRectangleModel) {
        enteredColorRectangleModel = model
    }
    
    func onDropEntered(_ model: ColorRectangleModel) {
        self.enteredColorRectangleModel = model
    }
    
    func performDrop(_ model: ColorRectangleModel) {
        swapPosition()
        draggedColorRectangleModel = nil
    }
    
    private func swapPosition() {
        guard let draggedColorRectangleModel, let enteredColorRectangleModel else { return }
        
        guard let draggedIndex = colorRectangleModels.firstIndex(where: {
            $0.id == draggedColorRectangleModel.id
        }) else { return }
        
        guard let enteredIndex = colorRectangleModels.firstIndex(where: {
            $0.id == enteredColorRectangleModel.id
        }) else { return }
        
        let tmp = colorRectangleModels[enteredIndex]
        
        withAnimation {
            colorRectangleModels[enteredIndex] = draggedColorRectangleModel
            colorRectangleModels[draggedIndex] = tmp
        }
    }
}
