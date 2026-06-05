//
//  PlaceholderClient.swift
//  CaseStudies-TCA-SwiftUI
//
//  Created by 노우영 on 3/24/25.
//  Copyright © 2025 Page. All rights reserved.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct PlaceholderClient {
    var fetchPost: (_ id: Int) async throws -> (String, String)
}

extension PlaceholderClient: DependencyKey {
    static var liveValue: PlaceholderClient {
        Self { id in
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let post = try JSONDecoder().decode(Post.self, from: data)
            return (post.title, post.body)
        }
    }
    
    static let mockValue: PlaceholderClient = Self { id in
        return ("title[\(id)]", "description[\(id)]")
    }
    
    static let previewValue: PlaceholderClient = Self { id in
        return ("title[\(id)]", "description[\(id)]")
    }
    
    
}

extension DependencyValues {
    var placeholderClient: PlaceholderClient {
        get { self[PlaceholderClient.self] }
        set { self[PlaceholderClient.self] = newValue }
    }
}

private struct Post: Decodable {
    let title: String
    let body: String
}
