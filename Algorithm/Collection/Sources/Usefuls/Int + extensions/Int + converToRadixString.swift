//
//  Int + toBinary.swift
//  PageCollection
//
//  Created by 노우영 on 9/4/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

extension Int {
    /// 참고용 코드다.
    /// 숫자를 진수로 변환하는거 까먹을 경우 활용하자. 
    func converToRadixString(radix: Int) -> String {
        String(self, radix: radix)
    }
}
