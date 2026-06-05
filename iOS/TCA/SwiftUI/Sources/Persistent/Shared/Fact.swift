//
//  Fact.swift
//  CaseStudies-TCA
//
//  Created by 노우영 on 1/23/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import GRDB

struct Fact: Codable, Equatable, Identifiable, FetchableRecord,
             MutablePersistableRecord {
    
    static let databaseTableName = "facts"
    
    var id: Int64?
    var number: Int
    var savedAt: Date
    var value: String
    
    mutating func didInsert(_ inserted: InsertionSuccess) {
      id = inserted.rowID
    }
}
