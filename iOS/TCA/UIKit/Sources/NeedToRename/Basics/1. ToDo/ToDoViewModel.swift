//
//  ToDoViewModel.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import Combine

class ToDoViewModel: InputFieldDelegate {
    @Published var inputFieldViewModel: InputFieldViewModel
    
    @Published var textList: [ToDoCellState] = [
        ToDoCellState(toDo: ToDo(description: "Hello", number: 1))
    ]
    var count = 2
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.inputFieldViewModel = InputFieldViewModel()
        
        inputFieldViewModel.addTextSubject
            .sink { [weak self] text in
                self?.didAddTextTapped(text)
            }
            .store(in: &cancellables)
    }
    
    func didAddTextTapped(_ text: String) {
        guard !text.isEmpty else { return }
        
        let toDo = ToDo(description: text, number: count)
        
        textList.append(ToDoCellState(toDo: toDo))
        
        count += 1
        
    }
}
