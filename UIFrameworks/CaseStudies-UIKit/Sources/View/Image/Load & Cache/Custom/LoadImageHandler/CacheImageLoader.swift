//
//  CacheImageLoader.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class CacheImageLoader: LoadImageHandler {
    
    static let `default` = CacheImageLoader()
    
    
    var next: (any LoadImageHandler)?
    let imageCache = NSCache<NSString, UIImage>()
    
    private init() {
        self.next = nil
    }
    
    func loadImage(fromKey key: String) async throws -> UIImage {
        let nsKey = key as NSString
        if let result = imageCache.object(forKey: nsKey) {
            return result
        } else if let result = try await next?.loadImage(fromKey: key) {
            imageCache.setObject(result, forKey: nsKey)
            return result
        }
        
        throw ImageLoadingError.loadFail
    }
}
