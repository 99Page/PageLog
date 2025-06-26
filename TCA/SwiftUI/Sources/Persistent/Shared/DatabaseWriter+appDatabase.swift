//
//  DatabaseWriter+appDatabase.swift
//  CaseStudies-TCA
//
//  Created by 노우영 on 1/23/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import GRDB
import IssueReporting


extension DatabaseWriter where Self == DatabaseQueue {
    static var appDatabase: DatabaseQueue {
        let databaseQueue: DatabaseQueue
        var configuration = Configuration()
        configuration.prepareDatabase { db in
            db.trace(options: .profile) {
#if DEBUG
                print($0.expandedDescription)
#else
                print($0)
#endif
            }
        }
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil && !isTesting {
            let path = URL.documentsDirectory.appending(component: "db.sqlite").path()
            print("open", path)
            databaseQueue = try! DatabaseQueue(path: path, configuration: configuration)
        } else {
            databaseQueue = try! DatabaseQueue(configuration: configuration)
        }
        
        var migrator = DatabaseMigrator()
        
        // Point-free 예제에서는 기존에 UserDefault를 사용해서 migrator가 필요한데,
        // 나는 바로 SharedReader를 사용했기때문에 migration이 필요하지는 않았다.
        // 하지만 migrator 코드 내에 테이블과 scheme을 정의하는 코드가 포함되어 있어서 그대로 사용했다.
        // 테이블 정의하는 것은 GRDB 를 살펴봐야 알기때문에 우선은 이대로 사용한다. 
        migrator.registerMigration("Add 'facts' table") { db in
            try db.create(table: "facts") { table in
                table.autoIncrementedPrimaryKey("id")
                table.column("number", .integer).notNull()
                table.column("savedAt", .datetime).notNull()
                table.column("value", .text).notNull()
            }
        }
        
        do {
            try migrator.migrate(databaseQueue)
        } catch {
            reportIssue(error)
        }
        return databaseQueue
    }
}
