//
//  Read.swift
//  PageCollection
//
//  Created by 노우영 on 8/29/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation

func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
