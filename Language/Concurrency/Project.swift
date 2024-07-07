//
//  Project.swift
//  PageComponentManifests
//
//  Created by 노우영 on 6/29/24.
//

import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let concurrencyTarget = Target.target(
    name: "Concurrency",
    destinations: .macOS,
    product: .commandLineTool,
    bundleId: "com.page.language.concurrency",
    deploymentTargets: .macOS("14.5"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"]
)

let tooltipProject = Project(
    name: "Concurrency",
    organizationName: "Page",
    targets: [concurrencyTarget]
)



