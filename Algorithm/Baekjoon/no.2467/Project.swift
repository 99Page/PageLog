//
//  Project.swift
//  ConcurrencyManifests
//
//  Created by 노우영 on 7/27/24.
//

import ProjectDescription

let name = "no.2467"

let target = Target.target(
    name: name,
    destinations: .macOS,
    product: .commandLineTool,
    bundleId: "com.page.backjoon.\(name)",
    deploymentTargets: .macOS("14.5"),
    sources: ["Sources/**"]
)

let project = Project(
    name: name,
    organizationName: "Page",
    targets: [target]
)


