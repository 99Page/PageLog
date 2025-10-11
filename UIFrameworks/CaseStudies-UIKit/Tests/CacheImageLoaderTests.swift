//
//  CacheImageLoaderTests.swift
//  CaseStudies-UIKitTests
//
//  Created by 노우영 on 10/11/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Testing
import PageKit
import UIKit
@testable import CaseStudies_UIKit

struct Test {
    func throwsError() throws {
        
    }
}

struct CacheImageLoaderTests {
    let cache = CacheImageLoader()
    
    @Test
    func keyDataRace_sameKeyHeavy() async throws {
        let key = "audi"
        let iterations = 1001

        let nsKey = key as NSString
        let audi = UIImage(resource: .audi)
        cache.imageCache.setObject(audi, forKey: nsKey)
        
        try await #require(throws: Never.self, "") {
            try await cache.loadImage(fromKey: key)
        }

        await withTaskGroup(of: Void.self) { group in
            for i in 0..<iterations {
                group.addTask {
                    switch i % 2 {
                    case 0:
                        // 삭제 작업: keys 집합과 NSCache 사이 일관성 경합 유도
                        cache.deleteImage(key: key)

                    default:
                        cache.imageCache.setObject(audi, forKey: nsKey)
                    }
                }
            }
            await group.waitForAll()
        }
        
        await #expect(throws: ImageLoadingError.loadFail) {
            try await cache.loadImage(fromKey: key)
        }
    }
}
