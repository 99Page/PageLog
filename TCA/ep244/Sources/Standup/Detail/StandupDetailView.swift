//
//  StandupDetailView.swift
//  TCA-244
//
//  Created by 노우영 on 8/21/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StandupDetailFeature {
    struct State: Equatable {
        @PresentationState var editStandup: StandupFormFeature.State?
        var standup: Standup
    }
    
    enum Action {
        case deleteButtonTapped
        case deleteMeetings(atOffset: IndexSet)
        case editButtonTapped
        case editStanup(PresentationAction<StandupFormFeature.Action>)
        case cancelStandupButtonTapped
        case saveStandupButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deleteButtonTapped:
                return .none
            case let .deleteMeetings(atOffset):
                state.standup.meetings.remove(atOffsets: atOffset)
                return .none
            case .editButtonTapped:
                state.editStandup = StandupFormFeature.State(standup: state.standup)
                return .none
            case .editStanup(_):
                return .none
            case .cancelStandupButtonTapped:
                state.editStandup = nil
                return .none
            case .saveStandupButtonTapped:
                guard let standup = state.editStandup?.standup
                else { return .none }
                
                state.standup = standup
                state.editStandup = nil
                
                return .none
            }
        }
        .ifLet(\.$editStandup, action: \.editStanup) {
            StandupFormFeature()
        }
    }
}

struct StandupDetailView: View {
    
    let store: StoreOf<StandupDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                Section {
                    NavigationLink {
                        
                    } label: {
                        Label("Start meeting", systemImage: "timer")
                            .font(.headline)
                            .foregroundStyle(Color.accentColor)
                    }
                    
                    HStack {
                        Label("Length", systemImage: "clock")
                        Spacer()
                        Text(viewStore.standup.duration.formatted(.units()))
                    }
                    
                    HStack {
                        Label("Theme", systemImage: "paintpalette")
                        Spacer()
                        Text(viewStore.standup.theme.name)
                            .padding(4)
                            .foregroundStyle(viewStore.standup.theme.accentColor)
                            .background(viewStore.standup.theme.mainColor)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                } header: {
                    Text("Standup Info")
                }
                
                if !viewStore.standup.meetings.isEmpty {
                    Section {
                        ForEach(viewStore.standup.meetings) { meeting in
                            NavigationLink {
                                
                            } label: {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text(meeting.date, style: .date)
                                    Text(meeting.date, style: .time)
                                }
                            }
                        }
                        .onDelete { indicies in
                            viewStore.send(.deleteMeetings(atOffset: indicies))
                        }
                    } header: {
                        Text("Past meetings")
                    }
                }
                
                Section {
                    ForEach(viewStore.standup.attendees) { attendee in
                        Label(attendee.name, systemImage: "person")
                    }
                }
                
                Section {
                    Button("Delete") {
                        viewStore.send(.deleteButtonTapped)
                    }
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Design")
            .toolbar {
                Button("Edit") {
                    viewStore.send(.editButtonTapped)
                }
            }
            .sheet(
                store: self.store.scope(
                    state: \.$editStandup,
                    action: \.editStanup
                )
            ) { store in
                NavigationStack {
                    /// Sheet으로 나오는 뷰는 독립적으로 봐야할거 같은데
                    /// Action을 공유하는 건 좀 별로인거 같다.
                    StandupFormView(store: store)
                        .navigationTitle("New standup")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel") {
                                    viewStore.send(.cancelStandupButtonTapped)
                                }
                            }
//                            
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Save") {
                                    viewStore.send(.saveStandupButtonTapped)
                                }
                            }
                        }
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        StandupDetailView(store: Store(initialState: StandupDetailFeature.State(standup: .mock), reducer: {
            StandupDetailFeature()
        }))
    }
}