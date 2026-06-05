//
//  CaseProtocol.swift
//  SwiftLog
//
//  Created by 노우영 on 1/8/26.
//  Copyright © 2026 Page. All rights reserved.
//

import Foundation

// enum에 특정 case 구현을 강제하도록 할 수 있습니다.

protocol CaseProtocol {
    static var cancel: Self { get }
    static func delegate(_ delegate: Delegate) -> Self
}

enum Delegate {
    case onAppear
    case onDisappear
}

enum ParentAction: CaseProtocol {
    case cancel
    case delegate(Delegate)
}
