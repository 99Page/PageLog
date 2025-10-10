//
//  Project.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/20/24.
//

import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen"
]

let projectName = "CaseStudies-TCA-SwiftUI"

let target = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.case.studies",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**", "Docs/**"],
    resources: ["../../Resource/Resources/**"],
    dependencies: [
        .project(target: "PageKit", path: .relativeToRoot("PageKit")),
        .package(product: "GRDB"),
    ]
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.tca.swiftui",
    deploymentTargets: .iOS("17.4"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: projectName)
    ]
)

let grdbURL = "https://github.com/groue/GRDB.swift.git"
let grdbVersion: Package.Requirement = .exact("6.29.3")


let project = Project(
    name: projectName,
    organizationName: "Page",
    packages: [
        .remote(url: grdbURL, requirement: grdbVersion)
    ],
    settings: nil,
    targets: [target, testTarget]
)


