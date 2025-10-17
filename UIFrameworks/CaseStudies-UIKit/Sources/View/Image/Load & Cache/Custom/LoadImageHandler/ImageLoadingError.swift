//
//  ImageLoadingError.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

enum ImageLoadingError: Error {
    case loadFail
    case taskCancellation
    case failToConvertToData
    case diskError(DiskError)
}

enum DiskError: Error {
    case invalidCacheURL
    case empty
}
