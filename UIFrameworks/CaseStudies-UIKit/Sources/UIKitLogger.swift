//
//  UIKitLogger.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import OSLog

enum UIKitLogger {
    
    private static let subsystem = Bundle.main.bundleIdentifier ?? "UIKitLogger"
    
    static func logDebug(_ message: String, category: String = "default") {
        let logger = Logger(subsystem: subsystem, category: category)
        logger.debug("\(message, privacy: .public)")
    }
}
