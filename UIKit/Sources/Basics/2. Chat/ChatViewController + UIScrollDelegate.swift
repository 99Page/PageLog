//
//  ChatViewController + UIScrollDelegate.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/20/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

extension ChatViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let lastVisibledIndex = tableView.lastVisibleIndexPath
        let isLastRowDisplayed = tableView.isLastRowDisplayed
        store.send(.scrollDetected(lastVisibleIndexPath: lastVisibledIndex, isScrolledToBottom: isLastRowDisplayed))
    }
}
