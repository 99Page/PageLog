//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 9/30/24.
//

import Foundation

import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let target = Target.target(
    name: "Swift",
    destinations: .macOS,
    product: .commandLineTool,
    bundleId: "com.page.swift",
    deploymentTargets: .macOS("14.5"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"]
)

let project = Project(
    name: "Swift",
    organizationName: "Page",
    targets: [target]
)



