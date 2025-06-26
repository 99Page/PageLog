//
//  EnumState.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 6/26/25.
//  Copyright © 2025 Page. All rights reserved.
//


import Foundation
import ComposableArchitecture
import SwiftUI


/// EnumStateFeature
///
/// 이 파일은 Enum 기반 상태(State enum case)를 TCA 구조에서 어떻게 관리하는지를 실습하기 위한 예제입니다.
/// 각 enum case는 공통된 Feature(`ColorFeature`)를 가지며, 현재 상태에 따라 색상을 변경합니다.
/// 버튼을 누르면 상태가 순환하면서 해당 색상의 ColorView가 보여집니다.
///
/// 상황에 따라 한개의 뷰만 사용해야할 때 유용합니다. 예를 들어 로그인-로그아웃을 통해 뷰를 전환하는 경우 사용할 수 있습니다.
@Reducer
struct EnumStateFeature {
    @ObservableState
    enum State {
        case blue(ColorFeature.State)
        case red(ColorFeature.State)
        case orange(ColorFeature.State)
    }
    
    enum Action: ViewAction {
        case blue(ColorFeature.Action)
        case red(ColorFeature.Action)
        case orange(ColorFeature.Action)
        case view(UIAction)
        
        enum UIAction {
            case buttonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.blue, action: \.blue) {
            ColorFeature()
        }
        
        Scope(state: \.red, action: \.red) {
            ColorFeature()
        }
        
        Scope(state: \.orange, action: \.orange) {
            ColorFeature()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .blue:
                return .none
            case .orange:
                return .none
            case .red:
                return .none
            case .view(.buttonTapped):
                switch state {
                case .blue:
                    state = .orange(.init(color: .orange))
                case .orange:
                    state = .red(.init(color: .red))
                case .red:
                    state = .blue(.init(color: .blue))
                }
                
                return .none
            }
        }
    }
}

@ViewAction(for: EnumStateFeature.self)
struct EnumStateView: View {
    
    let store: StoreOf<EnumStateFeature>
    
    var body: some View {
        VStack {
            if let store = store.scope(state: \.blue, action: \.blue) {
                ColorView(store: store)
            }
            
            if let store = store.scope(state: \.red, action: \.red) {
                ColorView(store: store)
            }
            
            if let store = store.scope(state: \.orange, action: \.orange) {
                ColorView(store: store)
            }
            
            Button {
                send(.buttonTapped)
            } label: {
                Text("색상 변경")
            }

        }
    }
}
