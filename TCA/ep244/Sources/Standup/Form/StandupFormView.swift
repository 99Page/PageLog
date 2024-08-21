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
    struct State {
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
                let attendeeId: Attendee.ID = UUID()
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
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addAttendeeButtonTapped:
                return .none
            }
        }
    }
}

struct StandupFormView: View {
    var body: some View {
        Form {
            Section {
                TextField("Title", text: .constant(""))
                HStack {
                    
                }
            }
        }
    }
}

#Preview {
    StandupFormView()
}
