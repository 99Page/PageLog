//
//  Environement + NavigateAction.swift
//  EnvironmentNavigation
//
//  Created by 노우영 on 9/7/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

protocol Navigatable: Hashable {
    associatedtype Destination: View
    var destination: Destination { get }
}

enum Route: Hashable, Navigatable {
    case color(ColorPath)
    
    var destination: some View {
        switch self {
        case .color(let colorRoute):
            colorRoute.destination
        }
    }
}

enum ColorPath: Navigatable {
    case blueScreen(text: String)
    case redScreen
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .blueScreen(let text):
            Text(text)
                .foregroundStyle(.blue)
        case .redScreen:
            Text("red screen!")
                .foregroundStyle(.red)
        }
    }
}

typealias NavigateAction = (Route) -> ()

struct NavigateEnvironmentKey: EnvironmentKey {
    static var defaultValue: (Route) -> () = { _ in }
}

extension EnvironmentValues {
    var navigate: (NavigateAction) {
        get { self[NavigateEnvironmentKey.self] }
        set { self[NavigateEnvironmentKey.self] = newValue }
    }
}
