//
//  ConfigurableCell.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

protocol ConfigurableCell: UIView {
    associatedtype Data
    
    init()
    
    func configure(data: Data)
    
    var dataIndex: Int { get set }
}
