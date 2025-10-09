//
//  ImageFetcher.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

class ImageFetcher {

    /// URL로부터 이미지를 비동기적으로 가져옵니다.
    /// - Parameter url: 이미지 URL
    /// - Returns: 이미지 데이터
    /// - Throws: 오류가 발생할 경우 예외를 던집니다.
    func fetchImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
