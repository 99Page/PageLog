//
//  CacheImageLoader.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

actor CacheKey {
    var cacheKeys: Set<NSString> = []
}


class CacheImageLoader: LoadImageHandler {
    
    static let `default` = CacheImageLoader()
    
    var next: (any LoadImageHandler)?
    let imageCache = NSCache<NSString, NSData>()
    var cacheKeys: Set<NSString> = []
    private let lock = NSLock()
    
    init() {
        self.next = nil
    }
    
    func loadImage(fromKey key: String) async throws -> Data {
       try await loadImage(fromKey: key as NSString)
    }
    
    func loadImage(fromKey nsKey: NSString) async throws -> Data {
        let key = String(nsKey)
        
        if let cacheHit = imageCache.object(forKey: nsKey) {
            return Data(cacheHit)
        }
        
        if let result = try await next?.loadImage(fromKey: key) {
            lock.withLock {
                imageCache.setObject(NSData(data: result), forKey: nsKey)
                cacheKeys.insert(nsKey)
            }
            return result
        }
        
        throw ImageLoadingError.loadFail
    }
    
    func deleteImage(key: String) {
        let nsKey = key as NSString
        
        lock.withLock {
            imageCache.removeObject(forKey: key as NSString)
            cacheKeys.remove(nsKey)
        }
        
    }
    
    func setData(key: String, data: Data) {
        lock.withLock {
            imageCache.setObject(NSData(data: data), forKey: key as NSString)
            cacheKeys.insert(key as NSString)
        }
    }
}
