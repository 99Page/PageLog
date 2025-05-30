//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 5/30/25.
//

import ProjectDescription

/// Macro를 활용하기 위한 프로젝트 설정
///
/// [Add macro dependency type to ProjectDescription](https://github.com/tuist/tuist/pulls?q=macro)
///
/// 이곳의 내용을 참고해서 프로젝트를 설정했습니다.
///
/// ```swift
///  .external(product: "SwiftSyntaxMacros") // ❌ 동작하지 않은 코드
///  .package(product: "SwiftSyntaxMacros") // ✅ 대체 코드
/// ```
let project = Project(
    name: "MacroKit",
    targets: [
        // MARK: Macro Targets + Tests
        .target(
            name: "MacroKitMacros",
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
            name: "MacroKit",
            destinations: [.iPhone, .iPad, .mac],
            product: .framework,
            bundleId: "io.tuist.TuistMacro",
            sources: ["TuistMacro/Sources/TuistMacro/**"],
            dependencies: [
                .target(name: "MacroKitMacros"),
            ]
        ),
        .target(
            name: "MacroKitClient",
            destinations: .macOS,
            product: .commandLineTool,
            bundleId: "io.tuist.TuistMacroClient",
            sources: ["TuistMacro/Sources/TuistMacroClient/**"],
            dependencies: [
                .target(name: "MacroKit"),
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
                .target(name: "MacroKitMacros"),
                .package(product: "SwiftSyntaxMacrosTestSupport"),
            ]
        ),
    ]
)

