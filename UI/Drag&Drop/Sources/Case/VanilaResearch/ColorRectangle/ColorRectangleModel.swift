//
//  ColorRectangleModel.swift
//  DragAndDrop
//
//  Created by wooyoung on 7/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

@Observable
final class ColorRectangleModel: Identifiable, DropDelegate {
    let color: Color
    weak var delegate: ColorRectangleDropDelegate?
    
    init(color: Color, delegate: ColorRectangleDropDelegate) {
        self.color = color
        self.delegate = delegate
    }
    
    func dropEntered(info: DropInfo) {
        delegate?.onDropEntered(self)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        delegate?.performDrop(self)
        return true
    }
}
