//
//  Project.swift
//
//  Created by 노우영 on 8/22/24.
//


import ProjectDescription

let problemNumber = "no.4485"
let target = Target.target(
    name: problemNumber,
    destinations: .macOS,
    product: .commandLineTool,
    bundleId: "com.page.backjoon.\(problemNumber)",
    deploymentTargets: .macOS("14.5"),
    sources: ["Sources/**"]
)

let project = Project(
    name: "\(problemNumber)",
    organizationName: "Page",
    targets: [target]
)


