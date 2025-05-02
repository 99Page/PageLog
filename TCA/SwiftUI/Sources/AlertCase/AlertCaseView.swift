//
//  AlertCaseView.swift
//  CaseStudies
//
//  Created by 노우영 on 12/17/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

/// Composable Architecture로 Alert 띄우는 예제 연습
///
/// [깃허브](https://github.com/pointfreeco/swift-composable-architecture)에 있는 예제 중, SyncUps를 참고.
@Reducer
struct AlertCaseFeature: Equatable {
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        case showAlertTapped
        
        @CasePathable
        enum Alert {
            case ok
            case cancel
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.ok)):
                return .none
            case .alert(.presented(.cancel)):
                return .none
            case .alert:
                return .none
            case .showAlertTapped:
                state.alert = AlertState {
                    TextState("Alert")
                } actions: {
                    ButtonState(action: .ok) {
                        TextState("OK")
                    }
                    
                    ButtonState(action: .cancel) {
                        TextState("CANCEL")
                    }
                }
                
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

struct AlertCaseView: View {
    
    @Bindable var store: StoreOf<AlertCaseFeature>
    
    var body: some View {
        Button {
            store.send(.showAlertTapped)
        } label: {
            Text("Show alert")
        }
        .alert($store.scope(state: \.alert, action: \.alert))

    }
}

#Preview {
    AlertCaseView(store: Store(initialState: AlertCaseFeature.State()) {
        AlertCaseFeature()
    })
}
