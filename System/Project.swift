//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 5/30/25.
//

import ProjectDescription

let project = Project(
    name: "ios_app_with_tuist_macro",
    targets: [
        // MARK: Macro Targets + Tests
        .target(
            name: "TuistMacroMacros",
            destinations: .macOS,
            product: .macro,
            bundleId: "io.tuist.TuistMacroMacros",
            deploymentTargets: .macOS("14.0"),
            sources: ["TuistMacro/Sources/TuistMacroMacros/**"],
            dependencies: [
                .package(product: "SwiftSyntaxMacros"),
                .package(product: "SwiftCompilerPlugin")
            ]
        ),
        .target(
            name: "TuistMacro",
            destinations: [.iPhone, .iPad, .mac],
            product: .framework,
            bundleId: "io.tuist.TuistMacro",
            sources: ["TuistMacro/Sources/TuistMacro/**"],
            dependencies: [
                .target(name: "TuistMacroMacros"),
            ]
        ),
        .target(
            name: "TuistMacroClient",
            destinations: .macOS,
            product: .commandLineTool,
            bundleId: "io.tuist.TuistMacroClient",
            sources: ["TuistMacro/Sources/TuistMacroClient/**"],
            dependencies: [
                .target(name: "TuistMacro"),
            ]
        ),
        .target(
            name: "TuistMacroTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.tuist.TuistMacroTests",
            deploymentTargets: .macOS("14.0"),
            infoPlist: .default,
            sources: ["TuistMacro/Tests/**"],
            dependencies: [
                .target(name: "TuistMacroMacros"),
                .package(product: "SwiftSyntaxMacrosTestSupport"),
            ]
        ),
    ]
)

