//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 12/10/24.
//

import Foundation


import ProjectDescription

let projectName = "PageResearch"

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
    bundleId: "com.page.research",
    deploymentTargets: .iOS("18.0"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../PageComponent/Resources/**"]
)

let project = Project(
    name: projectName,
    organizationName: "Page",
    targets: [target]
)
