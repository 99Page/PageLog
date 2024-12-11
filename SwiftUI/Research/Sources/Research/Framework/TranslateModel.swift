//
//  TranslateModel.swift
//  PageResearch
//
//  Created by 노우영 on 12/11/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

@Observable
final class TranslateModel {
    var isTranslationPresented: Bool = false
    
    var translationTarget: String = "" 
    var symbols = [
        "house", "bell", "eraser", "folder", "paperplane", "book", "dumbbell"
    ]
    
    var translatedSymbols: [String] = [] 
}
