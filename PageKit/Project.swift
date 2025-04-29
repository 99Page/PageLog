//
//  Project.swift
//
//  Created by 노우영 on 8/18/24.
//

import ProjectDescription

let projectName = "PageKit"

let target = Target.target(
    name: projectName,
    destinations: .macOS,
    product: .staticFramework,
    bundleId: "com.page.pageKit",
    deploymentTargets: .macOS("14.5"),
    sources: ["Sources/**"]
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .macOS,
    product: .unitTests,
    bundleId: "com.page.pageKit.tests",
    deploymentTargets: .macOS("14.5"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: projectName)
    ]
)

let project = Project(
    name: projectName,
    organizationName: "Page",
    targets: [target, testTarget]
)
