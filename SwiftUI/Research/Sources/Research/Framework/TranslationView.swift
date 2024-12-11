//
//  TranslationView.swift
//  PageResearch
//
//  Created by 노우영 on 12/11/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI
import Translation

/// 번역 기능을 확인하는 뷰
///
/// # Reference
/// [Meet the Translation API](https://developer.apple.com/videos/play/wwdc2024/10117/)
///
/// [Translating text within your app](https://developer.apple.com/documentation/translation/translating-text-within-your-app)
struct TranslationView: View {
    @State private var viewModel = TranslationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Button("Translate") {
                    viewModel.translateButtonTapped()
                }
                
                ForEach(viewModel.model.symbols.indices, id: \.self) { index in
                    symbolView(viewModel.model.symbols[index])
                }
                
                ForEach(viewModel.model.translatedSymbols.indices, id: \.self) { index in
                    Text(viewModel.model.translatedSymbols[index])
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .translationPresentation(
                isPresented: $viewModel.model.isTranslationPresented,
                text: viewModel.model.translationTarget
            )
        }
        .navigationTitle("Translation")
        .translationTask(viewModel.configuration) { session in
            await viewModel.onTranslated(using: session)
        }
    }
    
    private func symbolView(_ symbol: String) -> some View {
        HStack {
            Label(symbol, systemImage: symbol)
                .font(.title)
            
            Button {
                viewModel.symbolTranslateButtonTapped(symbol)
            } label: {
                Image(systemName: "translate")
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        TranslationView()
    }
}
