//
//  ImageStorage.swift
//  
//
//  Created by 노우영 on 11/4/25.
//

import Foundation

class ImageStorage {
    static let shared = ImageStorage()
    
//    var storage: [Date: Data] = [:]
    var storage: [String: Data] = [:]
    
    func store(_ image: UIImage) {
//        storage[.now] = image.pngData()!
        storage["cache"] = image.pngData()!
    }
}
