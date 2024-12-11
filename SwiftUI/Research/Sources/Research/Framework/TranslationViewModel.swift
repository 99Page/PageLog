//
//  TranslationViewModel.swift
//  PageResearch
//
//  Created by 노우영 on 12/11/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import Translation

@Observable
final class TranslationViewModel {
    var model = TranslateModel()
    var configuration: TranslationSession.Configuration?
    
    func symbolTranslateButtonTapped(_ symbol: String) {
        model.isTranslationPresented = true
        model.translationTarget = symbol
    }
    
    func translateButtonTapped() {
        guard configuration == nil else {
            configuration?.invalidate()
            return
        }
        
        
        // Let the framework automatically determine the language pairing.
        configuration = .init()
    }
    
    /// 여러 번여을 동시에 하는 방법
    func onTranslated(using session: TranslationSession) async {
        Task { @MainActor in
            do {
                let requests: [TranslationSession.Request] = model.symbols.map {
                    TranslationSession.Request(sourceText: $0)
                }
                
                let responses = try await session.translations(from: requests)
                self.model.translatedSymbols = responses.map {
                    $0.targetText
                }
            } catch {
                // Handle any errors.
            }
        }
    }
}
