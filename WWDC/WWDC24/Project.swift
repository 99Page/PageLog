//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 9/20/24.
//

import ProjectDescription

let projectName = "WWDC24"

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
    bundleId: "com.page.WWDC24",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../SwiftUI/PageComponent/Resources/**"]
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.WWDC24.tests",
    deploymentTargets: .iOS("17.4"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "WWDC24")
    ]
)

let project = Project(
    name: projectName,
    organizationName: "Page",
    targets: [target, testTarget]
)


