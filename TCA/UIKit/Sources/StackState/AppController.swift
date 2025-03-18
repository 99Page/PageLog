//
//  AppController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 2/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import UIKit


/// UIKit에서 StackAction을 발생시키는 방법을 알아보기 위한 파일.
///
/// TCA의 네비게이션 기능은 path, push, pop을 갖는 ``StackAction`` 기능을 제공합니다. push, pop은 뷰의 추가와 제거를 나타내고 path를 이용해 reducer에서 발생하는 action을 navigation을 관리하는 reducer 단에서 알 수 있습니다.
///
/// SwiftUI에서는 이를 별다른 어려움없이도 사용할 수 있는데, UIKit에서는 동일한 기능을 어떻게 사용할 수 있을지 간단히 구현해봤습니다.
///
/// 핵심은 StackAction을 사용하려면 StackState를 관리해야한다는 것입니다.
/// Point-free 예제를 잘 따라가면 SwiftUI에서는 신경쓸 점이 없습니다. 그런데 UIKit에서는 이를 동작시키기 어렵습니다. 예제를 보니 navigationController의 push를 사용해서 navigate를 하고 있었습니다.
///
/// NavigationLink로 StackState를 사용하는 과정을 짐작해보자면, 간단히 StackState에 새로운 State를 추가하는 과정일 것입니다. 따라서 UIKit에서도 각 path의 scoping만 잘 되어 있다면 StackState에 값을 추가함으로써 StackState를 사용할 수 있을 것이라고 짐작했습니다.
/// 결과는 맞았습니다.
///
/// StackState를 관리하는 NavigationViewController에, ``func push(state: Path.State)`` 함수만 구현해주면 SwiftUI 처럼 StackAction을 사용할 수 있습니다.
@Reducer
struct AppFeature {
    @Reducer
    enum Path {
        case count(CountFeature)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var rootFeature = RootFeature.State()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case rootFeature(RootFeature.Action)
        case push(Path.State)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.rootFeature, action: \.rootFeature) {
            RootFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .push(pathValue):
                state.path.append(pathValue)
                return .none
            case .path(.element(_, action: .count(.viewDidLoad))):
                state.rootFeature.count += 1
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

class AppController: NavigationStackController {
    private var store: StoreOf<AppFeature>!
    
    convenience init(store: StoreOf<AppFeature>) {
        @UIBindable var store = store
        
        
        self.init(path: $store.scope(state: \.path, action: \.path)) {
            RootViewController(store: store.scope(state: \.rootFeature, action: \.rootFeature))
        } destination: { store in
            switch store.case {
            case let .count(store):
                CountViewController(store: store)
            }
        }
        
        
        self.store = store
    }
    
    func push(state: AppFeature.Path.State) {
        store.send(.push(state))
    }
}
