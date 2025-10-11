//
//  DiskCacheTests.swift
//  CaseStudies-UIKitTests
//
//  Created by 노우영 on 10/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import XCTest
@testable import CaseStudies_UIKit

final class DiskCacheTests: XCTestCase {

    var loader = DiskImageLoader(config: .init(cacheFolderName: "test"))
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveImage() async throws {
        loader.saveImageToDisk(UIImage.remove.pngData()!, forKey: "remove")
        let imageData = try await loader.loadImage(fromKey: "remove")
        XCTAssertEqual(imageData, UIImage.remove.pngData()!)
    }
    
    func testRemoveSavedImage() async throws {
        let imageData = UIImage.remove.pngData()!
        let key = "remove"
        loader.saveImageToDisk(imageData, forKey: key)
        try loader.delete(forKey: key)
        
        do {
            let value = try await loader.loadImage(fromKey: key)
            debugPrint(value)
            XCTFail()
        } catch {
            if case let ImageLoadingError.diskError(diskError) = error {
                XCTAssertEqual(diskError, .empty)
            } else {
                XCTFail()
            }
        }
    }
    
    func testRemoveImage() async throws {
        let key = "remove"
        XCTAssertThrowsError(try loader.delete(forKey: key))
    }
}

