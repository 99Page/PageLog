//
//  UITableView+isScroleldToBottom.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/20/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    /// 테이블 뷰가 최하단에 스크롤되어 있는지 확인
    var isScrolledToBottom: Bool {
        let contentHeight = contentSize.height
        let tableViewHeight = bounds.size.height
        let bottomOffset = contentOffset.y + tableViewHeight
        
        return bottomOffset >= contentHeight - 1.0 // 약간의 오차 허용
    }

}
