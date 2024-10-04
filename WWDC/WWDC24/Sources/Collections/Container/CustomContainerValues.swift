//
//  CustomContainerValues.swift
//  WWDC24
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

/// section 전체에 적용할 수도 있고
/// 개별 subview 하나에 적용할 수도 있다.
/// ContainerView, SectionContainerView에서 어떻게 사용하고 있는지 비교해보자. 
extension ContainerValues {
    @Entry var foregroundColor: Color = .blue
}

extension View {
    func containerForegroundColor(_ color: Color) -> some View {
        containerValue(\.foregroundColor, color)
    }
}
