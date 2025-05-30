//
//  File.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 5/30/25.
//

@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "SystemMacros", type: "StringifyMacro")

