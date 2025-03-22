//
//  UITableView+isValidIndex.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/21/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit

extension UITableView {
    func isValidIndex(_ indexPath: IndexPath) -> Bool {
        let sectionCount = self.numberOfSections
        guard indexPath.section < sectionCount else { return false }
        
        let rowCount = self.numberOfRows(inSection: indexPath.section)
        return indexPath.row < rowCount
    }
}
