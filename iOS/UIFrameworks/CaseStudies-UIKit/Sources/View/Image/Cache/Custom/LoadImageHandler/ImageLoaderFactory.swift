//
//  ImageLoaderFactory.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

struct ImageLoaderFactory {
    static func makeHandler() -> any LoadImageHandler {
        let url = NetworkImageLoader()
        let disk = DiskImageLoader(next: url)
        let cache = CacheImageLoader(next: disk)
        return cache
    }
}
