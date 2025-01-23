//
//  FactModel.swift
//  CaseStudies-TCA
//
//  Created by 노우영 on 1/23/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import Dependencies
import Sharing
import SwiftUI

@Observable
class FactModel {
    enum Ordering: String, CaseIterable {
        case number
        case savedAt
    }
    
    var fact: String?
    var ordering: Ordering = .number
    
    @ObservationIgnored
    @Shared(.count) var count
    
    @ObservationIgnored
    @SharedReader(.fetchAll(#"SELECT * FROM "facts""#))
    var favoriteFacts: [Fact]
    
    @ObservationIgnored @Dependency(\.defaultDatabase) var database
    
    func decrementButtonTapped() {
        $count.withLock { $0 -= 1 }
        fact = nil
    }
    
    func incrementButtonTapped() {
        $count.withLock { $0 += 1 }
        fact = nil
    }
    
    func getFactButtonTapped() {
        self.fact = "Get \(count) fact!"
    }
    
    func favoriteFactButtonTapped() {
        guard let fact else { return }
        withAnimation {
          self.fact = nil
          do {
            try database.write { db in
                _ = try Fact(number: count, savedAt: .now, value: fact)
                .inserted(db)
            }
          } catch {
            reportIssue(error)
          }
        }
    }
    
    func deleteFacts(indexSet: IndexSet) {
      do {
        try database.write { db in
          _ = try Fact.deleteAll(db, ids: indexSet.map { favoriteFacts[$0].id })
        }
      } catch {
        reportIssue(error)
      }
    }
}

extension SharedKey where Self == AppStorageKey<Int>.Default {
    static var count: Self {
        Self[.appStorage("count"), default: 0]
    }
}
