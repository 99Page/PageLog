//
//  Project.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/21/24.
//

import ProjectDescription

let target = Target.target(
    name: "doc",
    destinations: .macOS,
    product: .bundle,
    bundleId: "com.page.backjoon.doc",
    deploymentTargets: .macOS("14.5"),
    sources: ["Sources/**"]
)

let project = Project(
    name: "doc",
    organizationName: "Page",
    targets: [target]
)



