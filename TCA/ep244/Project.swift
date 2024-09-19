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

let episodeNumber = "244"

let target = Target.target(
    name: "TCA-\(episodeNumber)",
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.tca.episode.\(episodeNumber)",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../SwiftUI/PageComponent/Resources/**"],
    dependencies: [
        .package(product: "ComposableArchitecture")
    ]
)

let testTarget = Target.target(
    name: "TCA-\(episodeNumber)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.tca.episode.\(episodeNumber).tests",
    deploymentTargets: .iOS("17.4"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "TCA-\(episodeNumber)")
    ]
)

let tcaURL = "https://github.com/pointfreeco/swift-composable-architecture.git"
let tcaVersion: Package.Requirement = .upToNextMajor(from: "1.15.0")


let project = Project(
    name: "TCA-\(episodeNumber)",
    organizationName: "Page",
    packages: [
        .remote(url: tcaURL, requirement: tcaVersion),
    ],
    settings: nil,
    targets: [target, testTarget]
)


