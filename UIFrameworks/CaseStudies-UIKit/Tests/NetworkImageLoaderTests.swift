//
//  NetworkImageLoaderTests.swift
//  CaseStudies-UIKitTests
//
//  Created by 노우영 on 10/10/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Testing
import PageKit
@testable import CaseStudies_UIKit
import UIKit

@Suite("")
struct NetworkImageLoaderTests {
    
    let loader = NetworkImageLoader()

    // 현재 timeout은 분단위만 가능 -page, 2025. 10. 10
    @Test(.timeLimit(.minutes(1)))
    func downloadAnImage() async throws {
        let stub = ImageURLs.stubs()[0]
        let image = try? await loader.loadImage(fromKey: stub.path())
        
        #expect(image != nil)
    }

    @Test(.timeLimit(.minutes(1)))
    func downloadMultipleImages() async throws {
        let stubs = Array(ImageURLs.stubs()[0..<5])

        var successCount = 0
        
        await withTaskGroup(of: Bool.self) { group in
            for stub in stubs {
                group.addTask { [loader] in
                    let image = try? await loader.loadImage(fromKey: stub.path())
                    return image != nil
                }
            }

            for await ok in group { if ok { successCount += 1 } }
        }

        #expect(successCount == stubs.count)
    }

    /// 네트워크 이미지 로딩 태스크를 취소했을 때, 취소 계열 에러로 종료되는지 검증합니다.
    /// - Important: 태스크가 실제로 시작된 뒤 취소되도록 한 틱 양보(`Task.yield()`)합니다.
    @Test(.timeLimit(.minutes(1)))
    func cancelDownloadAnImage() async {
        let stub = ImageURLs.stubs()[0]

        let task = Task { @Sendable () async throws -> UIImage in
            try await loader.loadImage(fromKey: stub.path())
        }

        // 태스크가 시작될 시간을 한 틱 부여한 뒤 취소
        await Task.yield()
        task.cancel()

        do {
            _ = try await task.value
            #expect(Bool(false), "Cancellation이 되지 않아서 실패")
        } catch {
            let loadFail = (error as? ImageLoadingError) == .taskCancellation
            #expect(loadFail)
        }
    }
}
