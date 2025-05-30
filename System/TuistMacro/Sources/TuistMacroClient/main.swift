//
//  File.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 5/30/25.
//

import TuistMacro

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

