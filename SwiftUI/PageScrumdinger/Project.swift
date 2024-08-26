//
//  Project.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 8/24/24.
//

import ProjectDescription

let projectName = "PageScrumdinger"

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let target = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.page.scrum.dinger",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../PageComponent/Resources/**"]
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.page.scrum.dinger.tests",
    deploymentTargets: .iOS("17.4"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "\(projectName)")
    ]
)


let project = Project(
    name: projectName,
    organizationName: "Page",
    targets: [target, testTarget]
)

