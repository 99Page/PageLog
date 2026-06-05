//
//  AppPath.swift
//  PageResearch
//
//  Created by 노우영 on 12/10/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

enum AppPath: Hashable {
    case symbol(SymbolPath)
    case animation(AnimationPath)
    case framework(FrameworkPath)
    case toolbar(ToolbarPath)
    case tab(TabPath)
}
