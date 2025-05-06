//
//  LoadImageHandler.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

protocol LoadImageHandler {
    var next: LoadImageHandler? { get set }
    func loadImage(fromKey key: String) async throws -> UIImage
}
