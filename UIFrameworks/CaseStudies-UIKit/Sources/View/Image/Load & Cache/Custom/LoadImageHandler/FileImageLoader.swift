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


class DiskImageLoader: LoadImageHandler {
    var next: (any LoadImageHandler)?
    
    static let `default` = DiskImageLoader()
    
    private var fileManager = FileManager.default
    private var config: Config
    
    init(next: (any LoadImageHandler)? = nil, config: Config = .init()) {
        self.next = next
        self.config = config
        try? createDirectory()
    }
    
    var cacheURL: URL {
        let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent(config.cacheFolderName, isDirectory: true)
    }
    
    func loadImage(fromKey key: String) async throws -> Data {
        let fileURL = fileURL(forKey: key)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
            if let image = try await next?.loadImage(fromKey: key) {
                return image
            } else {
                throw ImageLoadingError.diskError(.empty)
            }
        }
    }
    
    /// 디스크에 이미지를 저장합니다.
    /// - Parameter image: 저장할 이미지
    /// - Parameter urlString: 이미지 URL의 문자열 표현
    func saveImageToDisk(_ image: Data, forKey urlString: String) {
        let fileURL = fileURL(forKey: urlString)
        try? image.write(to: fileURL)
    }
    
    func delete(forKey key: String) throws {
        let fileURL = fileURL(forKey: key)
        try fileManager.removeItem(at: fileURL)
    }
    
    private func fileURL(forKey key: String) -> URL {
        cacheURL.appendingPathExtension(key.sha256())
    }
    
    private func createDirectory() throws {
        guard !fileManager.fileExists(atPath: cacheURL.path()) else { return }
        try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true, attributes: nil)
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

extension DiskImageLoader {
    struct Config {
        let cacheFolderName: String
        
        init(cacheFolderName: String = "ImageCache") {
            self.cacheFolderName = cacheFolderName
        }
    }
}
