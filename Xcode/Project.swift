//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 6/22/25.
//

import ProjectDescription

let projectName = "Xcode"

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
    bundleId: "com.page.xcode",
    deploymentTargets: .iOS("18.0"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../Resource/Resources/**"]
)

let project = Project(
    name: projectName,
    organizationName: "Page",
    targets: [target]
)

