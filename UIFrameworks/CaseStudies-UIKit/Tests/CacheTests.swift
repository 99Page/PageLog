//
//  CacheTests.swift
//  CaseStudies-UIKitTests
//
//  Created by 노우영 on 10/13/25.
//  Copyright © 2025 Page. All rights reserved.
//

import XCTest
@testable import CaseStudies_UIKit

struct LockCount {
    var lock = NSLock()
    var count = 0
    
    mutating func increase() {
        lock.lock()
        count += 1
        lock.unlock()
    }
}

final class CacheTests: XCTestCase {

    var loader = CacheImageLoader()

    func testDataraceCase() async throws {
        let workers = 100
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<workers {
                group.addTask {
                    self.loader.setData(key: "\(i)", data: UIImage.remove.pngData()!)
                }
            }
        }
        
        for key in loader.cacheKeys {
            XCTAssertNotNil(loader.imageCache.object(forKey: key))
        }
    }
}
