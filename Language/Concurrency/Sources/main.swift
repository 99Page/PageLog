//
//  Concurrency.swift
//
//  Created by 노우영 on 6/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

let task = Task {
    let result = await makeLevel1Tasks()
    
    print("final result: \(result)")
}

RunLoop.current.run(mode: .default, before: .distantFuture)

// MARK: Sendable

