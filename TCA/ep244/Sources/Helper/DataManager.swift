//
//  DataManager.swift
//  TCA-244
//
//  Created by 노우영 on 9/19/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct DataManager {
    var load: @Sendable (URL) throws -> Data
    var save: @Sendable (Data, URL) throws -> Void
}

extension DataManager: DependencyKey {
    static var liveValue: DataManager = DataManager { url in
        try Data(contentsOf: url)
    } save: { data, url in
        try data.write(to: url)
    }
    
    static let previewValue: DataManager = .mock()
    
    static let failToWrite = DataManager { url in
        Data()
    } save: { _, _ in
        throw SomeError()
    }
    
    static let failToLoad = DataManager { url in
        throw SomeError()
    } save: { _, _ in
        
    }
    
    static func mock(initialData: Data? = nil) -> DataManager {
        let data = LockIsolated(initialData)
        
        return DataManager { _ in
            guard let data = data.value else {
                throw SomeError()
            }
            return data
        } save: { newData, _ in
            data.setValue(newData)
        }

    }


    struct SomeError: Error { }
}

extension DependencyValues {
    var dataManager: DataManager {
        get { self[DataManager.self] }
        set { self[DataManager.self] = newValue }
    }
}
