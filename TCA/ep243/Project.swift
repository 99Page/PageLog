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

let target = Target.target(
    name: "TCA#243",
    destinations: .iOS,
    product: .framework,
    bundleId: "com.page.tca.episode.243",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../SwiftUI/PageComponent/Resources/**"],
    dependencies: [
        .package(product: "swift-composable-architecture")
    ]
)

let testTarget = Target.target(
    name: "TCA#243Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.tca.episode.243.tests",
    deploymentTargets: .iOS("17.4"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "TCA#243")
    ]
)

let tcaURL = "https://github.com/pointfreeco/swift-composable-architecture.git"
let tcaVersion: Package.Requirement = .upToNextMinor(from: "1.13.0")


let serviceProject = Project(
    name: "TCA#243",
    organizationName: "VauDium",
    packages: [
        .remote(url: tcaURL, requirement: tcaVersion),
    ],
    settings: nil,
    targets: [target, testTarget]
)


