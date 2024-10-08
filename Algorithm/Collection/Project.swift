//
//  Project.swift
//
//  Created by 노우영 on 8/18/24.
//

import ProjectDescription

let projectName = "PageCollection"

let target = Target.target(
    name: projectName,
    destinations: .macOS,
    product: .staticFramework,
    bundleId: "com.page.page.collection",
    deploymentTargets: .macOS("14.5"),
    sources: ["Sources/**"]
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .macOS,
    product: .unitTests,
    bundleId: "com.page.collection.tests",
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
