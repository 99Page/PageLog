//
//  ActionSender.swift
//  UILog
//
//  Created by 노우영 on 1/9/26.
//  Copyright © 2026 Page. All rights reserved.
//

import Foundation
import Combine

struct ActionStore<Action> {
    private let _send: (Action) -> Void
    let publisher: AnyPublisher<Action, Never>
    
    init(send: @escaping (Action) -> Void, publisher: AnyPublisher<Action, Never>) {
        self._send = send
        self.publisher = publisher
    }
    
    func send(_ action: Action) {
        _send(action)
    }
    
    func scope<ChildAction>(
        to childKeyPath: KeyPath<Action, ChildAction?>,
        from embed: @escaping (ChildAction) -> Action
    ) -> ActionStore<ChildAction> {
        
        let childPublisher = publisher
            .compactMap { $0[keyPath: childKeyPath] }
            .eraseToAnyPublisher()
        
        let childSend: (ChildAction) -> Void = { childAction in
            self.send(embed(childAction))
        }
        
        return ActionStore<ChildAction>(
            send: childSend,
            publisher: childPublisher
        )
    }
}

final class CViewModel {
    enum Action {
        case logout
    }
    
    private let store: ActionStore<Action>
    private var cancellables = Set<AnyCancellable>()
    
    init(store: ActionStore<Action>) {
        self.store = store
    }
    
    func didTapLogoutButton() {
        store.send(.logout)
    }
}

final class BViewModel {
    enum Action {
        case cAction(CViewModel.Action)
        
        var cAction: CViewModel.Action? {
            guard case let .cAction(val) = self else { return nil }
            return val
        }
    }
    
    let cViewModel: CViewModel
    private let store: ActionStore<Action>
    
    init(store: ActionStore<Action>) {
        self.store = store
        
        self.cViewModel = CViewModel(
            store: store.scope(to: \.cAction, from: Action.cAction)
        )
    }
}

final class AViewModel {
    enum Action {
        case bAction(BViewModel.Action)
        
        var bAction: BViewModel.Action? {
            guard case let .bAction(val) = self else { return nil }
            return val
        }
    }
    
    private let subject = PassthroughSubject<Action, Never>()
    private var cancellables = Set<AnyCancellable>()
    let bViewModel: BViewModel
    
    init() {
        let rootStore = ActionStore<Action>(
            send: { [weak subject] action in
                subject?.send(action)
            },
            publisher: subject.eraseToAnyPublisher()
        )
    
        self.bViewModel = BViewModel(store: rootStore.scope(to: \.bAction, from: Action.bAction))
        
        bind()
    }
    
    private func bind() {
        subject
            .sink { action in
                switch action {
                case .bAction(.cAction(.logout)):
                    print("A: C -> B -> A 순서로 전달된 로그아웃 이벤트를 처리합니다.")
                }
            }
            .store(in: &cancellables)
    }
}
