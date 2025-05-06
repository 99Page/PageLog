//
//  CacheImageLoader.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

struct CacheImageLoader: LoadImageHandler {
    var next: (any LoadImageHandler)?
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(fromKey key: String) async throws -> UIImage {
        let nsKey = key as NSString
        
        if let result = Self.imageCache.object(forKey: nsKey) {
            return result
        } else if let result = try await next?.loadImage(fromKey: key) {
            Self.imageCache.setObject(result, forKey: nsKey)
            return result
        }
        
        throw ImageLoadingError.loadFail
    }
}
