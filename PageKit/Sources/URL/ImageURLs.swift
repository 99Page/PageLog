//
//  ImageURLs.swift
//  PageKit
//
//  Created by 노우영 on 10/10/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation

public enum ImageURLs {
    public static func stubs() -> [URL] {
        let range = 1...20
        let urls = range.map { "https://picsum.photos/id/\($0)/200/300" }
        return urls.compactMap { URL(string: $0) }
    }
}
