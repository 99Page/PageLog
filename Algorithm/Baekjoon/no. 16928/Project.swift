//
//  Project.swift
//  ConcurrencyManifests
//
//  Created by 노우영 on 7/27/24.
//

import ProjectDescription


let target = Target.target(
    name: "no16928",
    destinations: .macOS,
    product: .commandLineTool,
    bundleId: "com.page.backjoon.no16928",
    deploymentTargets: .macOS("14.5"),
    sources: ["Sources/**"]
)

let project = Project(
    name: "no16928",
    organizationName: "Page",
    targets: [target]
)


