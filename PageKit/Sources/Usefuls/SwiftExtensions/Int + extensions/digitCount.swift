//
//  digitCount.swift
//  PageCollection
//
//  Created by 노우영 on 10/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Int {
     /// - Returns: 정수의 자리수
    var digitCount: Int {
         return String(abs(self)).count
    }
}
