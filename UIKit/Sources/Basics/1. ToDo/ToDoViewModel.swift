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
    @Published var textList: [String] = ["Hello"]
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.inputFieldViewModel = InputFieldViewModel()
        
        inputFieldViewModel.addTextSubject
            .sink { [weak self] text in
                self?.textList.append(text)
            }
            .store(in: &cancellables)
    }
    
    func didAddTextTapped(_ text: String) {
        guard !text.isEmpty else { return }
        
        textList.append(text)
        
    }
}
