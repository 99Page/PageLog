//
//  FetchAllKey.swift
//  CaseStudies-TCA
//
//  Created by 노우영 on 1/23/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Sharing
import IssueReporting
import Dependencies
import GRDB

private enum DefaultDatabaseKey: DependencyKey {
    static var liveValue: any DatabaseWriter {
        reportIssue(
                  """
                  A blank, in-memory database is being used for the app. \
                  Override this dependency in the entry point of your app.
                  """
        )
        
        return try! DatabaseQueue() // inMemory Database가 반환된다.
        
        // return .appDatabase를 해도 괜찮은데 왜 이런식으로 처리했는지는 잘 모르겠다.
        // 사용자가 "명시적으로 데이터를 선언할 수 있도록 한다" 고 영상에 나와있는데,
        // prepareDependecies를 사용하는 것과 여기서 .appDatabase로 반환하는 것의 차이가
        // 잘 와닿지는 않는다.
    }
}

extension SharedReaderKey {
    static func fetchAll<Record>(
        _ sql: String
    ) -> Self where Self == FetchAllKey<Record>.Default {
        Self[FetchAllKey(sql: sql), default: []]
    }
}

struct FetchAllKey<Record: FetchableRecord & Sendable>: SharedReaderKey {
    let database: any DatabaseReader
    let sql: String
    
    init(sql: String) {
        @Dependency(\.defaultDatabase) var database
        self.database = database
        self.sql = sql
    }
    
    
    struct ID: Hashable {
      let databaseObjectIdentifier: ObjectIdentifier
      let sql: String
    }
    
    var id: ID {
        ID(databaseObjectIdentifier: ObjectIdentifier(database), sql: sql)
    }
    
    func load(
        context: LoadContext<[Record]>,
        continuation: LoadContinuation<[Record]>
    ) {
        continuation.resume(
            with: Result {
                try database.read { db in
                    try Record.fetchAll(db, sql: sql)
                }
            }
        )
    }
    
    func subscribe(
        context: LoadContext<[Record]>,
        subscriber: SharedSubscriber<[Record]>
    ) -> SharedSubscription {
        let cancellable = ValueObservation.tracking { db in
            try Record.fetchAll(db, sql: sql)
        }
            .start(in: database, scheduling: .async(onQueue: .main)) { error in
                subscriber.yield(throwing: error)
            } onChange: { records in
                subscriber.yield(records)
            }
        return SharedSubscription {
            cancellable.cancel()
        }
    }
}

extension DependencyValues {
    var defaultDatabase: any DatabaseWriter {
        get { self[DefaultDatabaseKey.self] }
        set { self[DefaultDatabaseKey.self] = newValue }
    }
}
