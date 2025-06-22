//
//  Project.swift
//  PageComponentManifests
//
//  Created by wooyoung on 7/25/24.
//

import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let target = Target.target(
    name: "ReseachPreferenceKey",
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.research.preferenceKey",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../../Resource/Resources/**"]
)

let project = Project(
    name: "ReseachPreferenceKey",
    organizationName: "Page",
    targets: [target]
)



