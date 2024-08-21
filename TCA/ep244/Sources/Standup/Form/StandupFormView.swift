//
//  StandupFormView.swift
//  TCA-243Tests
//
//  Created by 노우영 on 8/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct StandupFormFeature: Reducer {
    struct State: Equatable {
        /// TextField처럼 뷰에 바인딩이 필요한 경우는 총 4가지를 기억하자
        /// 1. BindingState -> State에서 바인딩이 필요한 프로퍼티에서 선언
        /// 2. Action: BindableAction 프로토콜 채택
        /// 3. Action의 case에 BindingAction 추가
        /// 4. Reducer 앞에 `BindingReducer()` 선언
        @BindingState var standup: Standup
        @BindingState var focus: Field?
        
        enum Field: Hashable {
            case attendee(Attendee.ID)
            case title
        }
        
        init(standup: Standup, focus: Field? = .title) {
            self.standup = standup
            self.focus = focus
            
            if self.standup.attendees.isEmpty {
                @Dependency(\.uuid) var uuid
                let attendeeId: Attendee.ID = uuid()
                let attendee = Attendee(id: attendeeId)
                self.standup.attendees.append(attendee)
            }
        }
    }
    
    enum Action: BindableAction {
        case addAttendeeButtonTapped
        case binding(BindingAction<State>)
        case deleteAttendees(atOffsets: IndexSet)
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .addAttendeeButtonTapped:
                let attendeeId = self.uuid()
                let newAttendee = Attendee(id: attendeeId)
                state.standup.attendees.append(newAttendee)
                state.focus = .attendee(attendeeId)
                return .none
            case .binding(_):
                return .none
            case let .deleteAttendees(atOffsets: indices):
                state.standup.attendees.remove(atOffsets: indices)
                
                if state.standup.attendees.isEmpty {
                    let newAttendee = Attendee(id: self.uuid())
                    state.standup.attendees.append(newAttendee)
                }
                
                guard let firstIndex = indices.first 
                else { return .none }
                
                let index = min(firstIndex, state.standup.attendees.count - 1)
                state.focus = .attendee(state.standup.attendees[index].id)
                return .none
            }
        }
    }
}

struct StandupFormView: View {
    
    let store: StoreOf<StandupFormFeature>
    @FocusState var focus: StandupFormFeature.State.Field?
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    /// 바인딩되는 값들이 변경될 때 어떤 이벤트를 실행하고 싶으면
                    /// SwiftUI에서는 onChangeOf를 사용해야되고,
                    /// 이게 디버깅하기 제일 어려운 부분이다.
                    /// TCA에서는 이걸 어떻게 해결했을까?
                    TextField("Title", text: viewStore.$standup.title)
                        .focused(self.$focus, equals: .title)
                        
                    
                    HStack {
                        Slider(value: viewStore.$standup.duration.minute, in: 5...30, step: 1) {
                            Text("Minute")
                        }

                        Spacer()
                        
                        Text(viewStore.standup.duration.formatted(.units()))
                    }
                    
                    ThemePicker(selection: viewStore.$standup.theme)
                } header: {
                    Text("Standup Info")
                }
                
                Section {
                    ForEach(viewStore.$standup.attendees) { $attendee in
                        TextField("Name", text: $attendee.name)
                            .focused(self.$focus, equals: .attendee(attendee.id))
                    }
                    .onDelete  { indexSet in
                        viewStore.send(.deleteAttendees(atOffsets: indexSet))
                    }
                    
                    Button {
                        viewStore.send(.addAttendeeButtonTapped)
                    } label: {
                        Text("Add attendee")
                    }
                } header: {
                    Text("ATTENDEES")
                }
            }
            /// FocusState를 바인딩 하는 방법
            .bind(viewStore.$focus, to: self.$focus)
        }
    }
}

extension Duration {
    fileprivate var minute: Double {
        get { Double(self.components.seconds / 60) }
        set { self = .seconds(newValue * 60)}
    }
}

#Preview {
    StandupFormView(store: Store(initialState: StandupFormFeature.State(standup: .mock)) {
        StandupFormFeature()
    })
}
