//
//  UITableView+lastVisibleIndexPath.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/20/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    var lastVisibleIndexPath: IndexPath? {
        self.indexPathsForVisibleRows?.last
    }
    
    /// Returns the IndexPath of the last row in the table view.
    /// If the table view is empty, returns nil.
    var lastIndexPath: IndexPath? {
        let lastSection = numberOfSections - 1
        guard lastSection >= 0 else { return nil } // No sections
        
        let lastRow = numberOfRows(inSection: lastSection) - 1
        guard lastRow >= 0 else { return nil } // No rows in last section
        
        return IndexPath(row: lastRow, section: lastSection)
    }
    
    var isLastRowDisplayed: Bool {
        lastVisibleIndexPath == lastIndexPath
    }
}
