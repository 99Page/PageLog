//
//  Project.swift
//  TooltipManifests
//
//  Created by wooyoung on 7/19/24.
//

import ProjectDescription

let projectName = "DragAndDrop"

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let dragAndDropTarget = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.drag.and.drop",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../../Resource/Resources/**"]
)

let dragAndDropProject = Project(
    name: projectName,
    organizationName: "Page",
    targets: [dragAndDropTarget]
)

