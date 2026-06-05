//
//  CommunicationApp.swift
//  ApplePhotosEffectManifests
//
//  Created by 노우영 on 9/3/24.
//

import ProjectDescription

let projectName = "Communication"

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
    bundleId: "com.page.communication",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../../Resource/Resources/**"]
)

let project = Project(
    name: projectName,
    organizationName: "Page",
    targets: [target]
)


