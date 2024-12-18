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

let projectName = "CaseStudies"

let target = Target.target(
    name: "CaseStudies",
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.case.studies",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**", "Docs/**"],
    resources: ["../../SwiftUI/PageComponent/Resources/**"],
    dependencies: [
        .package(product: "ComposableArchitecture")
    ]
)

let testTarget = Target.target(
    name: "CaseStudiesTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.case.stuides.test",
    deploymentTargets: .iOS("17.4"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "CaseStudies")
    ]
)

let tcaURL = "https://github.com/pointfreeco/swift-composable-architecture.git"
let tcaVersion: Package.Requirement = .upToNextMajor(from: "1.17.0")


let project = Project(
    name: "CaseStudies",
    organizationName: "Page",
    packages: [
        .remote(url: tcaURL, requirement: tcaVersion),
    ],
    settings: nil,
    targets: [target, testTarget]
)


