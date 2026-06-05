//
//  FileImageLoader.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto


struct DiskImageLoader: LoadImageHandler {
    var next: (any LoadImageHandler)?
    
    /// 디스크에 저장된 이미지 경로
    private static let fileManager = FileManager.default
    private static var cacheDirectoryURL: URL? {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths.first?.appendingPathComponent("ImageCache")
    }
    
    func loadImage(fromKey key: String) async throws -> UIImage {
        guard let cacheDirectoryURL = Self.cacheDirectoryURL else {
            if let image = try await next?.loadImage(fromKey: key) {
                return image
            } else {
                throw ImageLoadingError.loadFail
            }
        }
        
        let fileURL = cacheDirectoryURL.appendingPathComponent(key.sha256())
        
        guard let imageData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: imageData) else {
            if let image = try await next?.loadImage(fromKey: key) {
                saveImageToDisk(image, forKey: key)
                return image
            } else {
                throw ImageLoadingError.loadFail
            }
        }
        
        return image
    }
    
    /// 디스크에 이미지를 저장합니다.
    /// - Parameter image: 저장할 이미지
    /// - Parameter urlString: 이미지 URL의 문자열 표현
    private func saveImageToDisk(_ image: UIImage, forKey urlString: String) {
        guard let cacheDirectoryURL = Self.cacheDirectoryURL else { return }
        
        // 캐시 디렉토리가 없다면 생성
        if !Self.fileManager.fileExists(atPath: cacheDirectoryURL.path) {
            try? Self.fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        let fileURL = cacheDirectoryURL.appendingPathComponent(urlString.sha256())
        
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
}

fileprivate extension String {
    // SHA-256 해시를 통해 파일명으로 사용 가능한 문자열 반환
    func sha256() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

