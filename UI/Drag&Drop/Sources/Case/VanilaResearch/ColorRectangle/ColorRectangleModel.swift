//
//  ColorRectangleModel.swift
//  DragAndDrop
//
//  Created by wooyoung on 7/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// List 내부에 Item이 있을 때 DropDelegate는 Item의 모델 혹은 뷰에서 conform 해야한다.
/// 어떤 뷰에서 drop됐는지 파악하는게 중요한데, List에서 처리하면 이걸 확인할 수 없다.
/// 또, 처리 결과 (drop된 곳이 어떤 뷰인지)는 List에서 관리해야하기 때문에
/// delegate 패턴을 사용해서 이걸 처리했다.
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
