//
//  ColorRectangleDropDelegate.swift
//  DragAndDrop
//
//  Created by wooyoung on 7/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

protocol ColorRectangleDropDelegate: AnyObject {
    func onDropEntered(_ model: ColorRectangleModel)
    func performDrop(_ model: ColorRectangleModel)
}
