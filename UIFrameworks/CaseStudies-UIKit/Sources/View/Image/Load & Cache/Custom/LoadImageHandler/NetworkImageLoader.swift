//
//  URLImageLoader.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class NetworkImageLoader: LoadImageHandler {
    var next: (any LoadImageHandler)?
    
    init(next: (any LoadImageHandler)? = nil) {
        self.next = next
    }
    
    /// URL로부터 이미지를 비동기적으로 로드하여 반환합니다.
    /// - Parameter urlString: 이미지 URL의 문자열 표현
    /// - Returns: 비동기적으로 로드된 UIImage
    func loadImage(fromKey key: String) async throws -> Data {
        guard let url = URL(string: key) else {
            throw ImageLoadingError.loadFail
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            if Task.isCancelled { throw ImageLoadingError.taskCancellation }
            throw error
        }
    }
}
