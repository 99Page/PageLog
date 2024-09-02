import Foundation
import ComposableArchitecture

@Reducer
struct StandupDetailFeature {
    struct State: Equatable {
        @PresentationState var desination: Destination.State?
        var standup: Standup
    }
    
    enum Action: Equatable {
        //        case alert(PresentationAction<Alert>)
        case deleteButtonTapped
        case deleteMeetings(atOffset: IndexSet)
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        case editButtonTapped
        //        case editStanup(PresentationAction<StandupFormFeature.Action>)
        case cancelStandupButtonTapped
        case saveStandupButtonTapped
        
        enum Alert {
            case confirmDeletion
        }
        
        enum Delegate: Equatable {
            case standupUpdate(Standup)
            case deleteStandup(id: Standup.ID)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    @Reducer
    struct Destination {
        enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            case editStandup(StandupFormFeature.State)
        }
        
        enum Action: Equatable {
            case alert(Alert)
            case editStandup(StandupFormFeature.Action)
            enum Alert {
                case confirmDeletion
            }
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.editStandup, action: \.editStandup) {
                StandupFormFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.alert(.confirmDeletion))):
                return .run { [id = state.standup.id] send in
                    await send(.delegate(.deleteStandup(id: id)))
                    await dismiss()
                }
            case .destination:
                return .none
            case .deleteButtonTapped:
                state.desination = .alert(
                    AlertState {
                        TextState("Are you sure want to delete?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion) {
                            TextState("Delete")
                        }
                    }
                )
                
                return .none
                
                /// ParentView는 이 동작을 감지할 수 있다.
                /// ChildView의 Action을 받고 ParentView를 동작시키고 싶으면 이런식으로 Delegate 사용하면 된다.
            case .delegate:
                return .none
            case let .deleteMeetings(atOffset):
                state.standup.meetings.remove(atOffsets: atOffset)
                return .none
                //                return .send(.delegate(.standupUpdate(state.standup)))
            case .editButtonTapped:
                let standupFormState = StandupFormFeature.State(standup: state.standup)
                state.desination = .editStandup(standupFormState)
                return .none
            case .cancelStandupButtonTapped:
                state.desination = nil
                return .none
            case .saveStandupButtonTapped:
                guard case let .editStandup(standupForm) = state.desination
                else { return .none}
                
                state.standup = standupForm.standup
                state.desination = nil
                
                return .none
            }
        }
        .ifLet(\.$desination, action: \.destination) {
            Destination()
        }
        .onChange(of: \.standup) { oldValue, newValue in
            Reduce { state, action in
                .send(.delegate(.standupUpdate(newValue)))
            }
        }
    }
}

