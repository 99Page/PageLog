//
//  TooltipRepository.swift
//  Tooltip
//
//  Created by wooyoung on 6/13/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI
import SwiftData

@Observable
class TooltipRepository {
    
    var tooltipCheck: [TooltipCheck] = []
    
    init() {
    }
    
    @MainActor
    func insert(_ tooltipCheck: TooltipCheck, context: ModelContext) {
        do {
            context.insert(tooltipCheck)
            try context.save()
        } catch {
            
        }
    }
    
    @MainActor
    func queryTrip(context: ModelContext) {
        do {
            let tooltips = FetchDescriptor<TooltipCheck>()
            let results = try context.fetch(tooltips)
            tooltipCheck = results
        } catch {
            
        }
    }
    
    func query(name: String, context: ModelContext) -> Bool {
        do {
            let description = FetchDescriptor<TooltipCheck>(
                predicate: #Predicate { $0.identifier == name }
            )
            
            let result = try context.fetch(description)
            
            debugPrint("result: \(result.description)")
            
            if let first = result.first {
                return !first.isChecked
            } else {
                return true
            }
        } catch {
            
            return false
        }
    }
}
