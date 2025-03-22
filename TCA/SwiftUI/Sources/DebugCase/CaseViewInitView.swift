//
//  ViewInitCaseView.swift
//  CaseStudies-TCA
//
//  Created by 노우영 on 12/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct TextType {
    let number: Int
}

@Reducer
struct ViewInitCaseFeature: Equatable {
    
    @ObservableState
    struct State: Equatable {
        var child1 = ViewInitChildFeature.State()
        var child2 = ViewInitChildFeature.State()
    }
    
    enum Action: Equatable {
        case child1(ViewInitChildFeature.Action)
        case child2(ViewInitChildFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.child1, action: \.child1) {
            ViewInitChildFeature()
        }
        
        Scope(state: \.child2, action: \.child2) {
            ViewInitChildFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .child1:
                return .none
            case .child2(_):
                return .none
            }
        }
    }
}


struct ViewInitCaseView: View {
    
    @State var count = 0
    
    let store: StoreOf<ViewInitCaseFeature>
    
    var body: some View {
        VStack {
            Button("Count: \(count)") {
                count += 1
            }
            
            /// count가 바뀌면 내부 body가 호출된다.
            /// State로 선언된 뷰는 값이 초기화가 되지 않지만,
            /// 그렇지 않은 뷰는 초기화가 된다.
            VanilaNoModelDataView() // 초기화 되는 뷰
            VanilaStateModelDataView() // 상태가 유지 되는 뷰
            
            /// 그러면 child로 넘겨진 state의 값이 바뀌면 어떻게 될까?
            /// 이 뷰에서 child state 값을 read하고 있지 않으니
            /// NoModelData 값이 초기화되지 않는다.
            /// 값이 변경되느냐의 유무가 아닌
            /// 값을 읽느냐의 유무로 기억해두자.
            ViewInitChildView(store: store.scope(state: \.child1, action: \.child1))
            ViewInitChildView(store: store.scope(state: \.child2, action: \.child2))
        }
    }
}

struct VanilaNoModelDataView: View {
    
    let type = TextType(number: .random(in: 0..<1000))
    
    var body: some View {
        Text("\(type.number)")
    }
}

struct VanilaStateModelDataView: View {
    
    @State var type = TextType(number: .random(in: 0..<1000))
    
    var body: some View {
        Text("\(type.number)")
    }
}

#Preview {
    ViewInitCaseView(store: Store(initialState: ViewInitCaseFeature.State()) {
        ViewInitCaseFeature()
    })
}
