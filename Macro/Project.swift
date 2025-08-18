//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 8/18/25.
//

import ProjectDescription

let macroTarget = Target.target(
    name: "MyMacroMacros",
    destinations: .macOS,
    product: .macro,
    bundleId: "com.example.MyMacroMacros",
    deploymentTargets: .macOS("13.0"),
    sources: ["Targets/MyMacroMacros/Sources/**"],
    dependencies: [
        .package(product: "SwiftSyntax"),
        .package(product: "SwiftParser"),
        .package(product: "SwiftCompilerPlugin"),
        .package(product: "SwiftSyntaxMacros"),
        .package(product: "SwiftSyntaxBuilder")
    ]
)

let macroLibrary = Target.target(
    name: "MyMacro",
    destinations: .macOS,
    product: .framework,
    bundleId: "com.example.MyMacro",
    deploymentTargets: .macOS("13.0"),
    sources: ["Targets/MyMacro/Sources/**"],
    dependencies: [
        .macro(name: "MyMacroMacros")
    ]
)

let macroClient = Target.target(
    name: "MyMacroClient",
    destinations: .macOS,
    product: .commandLineTool,
    bundleId: "com.example.MyMacroClient",
    deploymentTargets: .macOS("13.0"),
    sources: ["Targets/MyMacroClient/Sources/**"],
    dependencies: [
        .target(name: "MyMacro", status: .required, condition: nil)
    ]
)


let project = Project(
  name: "MyMacro",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  packages: [
    .remote(url: "https://github.com/swiftlang/swift-syntax.git", requirement: .upToNextMajor(from: "600.0.0"))
  ],
  targets: [macroTarget, macroLibrary, macroClient]
//
//    // 4) 매크로 테스트
//    Target(
//      name: "MyMacroTests",
//      platform: .macOS,
//      product: .unitTests,
//      bundleId: "com.example.MyMacroTests",
//      sources: ["Targets/MyMacroTests/Sources/**"],
//      dependencies: [
//        .target(name: "MyMacroMacros"),
//        .package(product: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
//      ]
//    )
)
