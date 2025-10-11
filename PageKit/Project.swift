//
//  Project.swift
//
//  Created by 노우영 on 8/18/24.
//

import ProjectDescription

let projectName = "PageKit"

let target = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "com.page.pageKit",
    deploymentTargets: .iOS("17.0"),
    sources: ["Sources/**"],
    dependencies: [
        .package(product: "Kingfisher"),
        .package(product: "SnapKit"),
        .package(product: "ComposableArchitecture"),
    ],
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "MAU8HFALP8"
        ]
    )
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.pageKit.tests",
    deploymentTargets: .iOS("17.0"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: projectName)
    ]
)

let project = Project(
    name: projectName,
    organizationName: "Page",
    packages: [
        .remote(
            url: "https://github.com/onevcat/Kingfisher.git",
            requirement: .upToNextMajor(from: "8.6.0")
        ),
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.7.1")
        ),
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            requirement: .upToNextMajor(from: "1.22.3")
        )
    ],
    targets: [target, testTarget],
)
