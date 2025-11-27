//
//  Project.swift
//  2023KakaoManifests
//
//  Created by Reppley_iOS on 4/18/25.
//

import Foundation
import ProjectDescription

let projectName = "CSLog"

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
    bundleId: "com.page.cs.log",
    deploymentTargets: .iOS("18.0"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"]
)

let project = Project(
    name: projectName,
    organizationName: "Page",
    targets: [target]
)
