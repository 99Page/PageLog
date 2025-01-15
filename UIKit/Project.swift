//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 1/14/25.
//

import Foundation
import ProjectDescription

let projectName = "CaseStudies-UIKit"

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let target = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.case.studies.uikit",
    deploymentTargets: .iOS("18.0"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../SwiftUI/PageComponent/Resources/**"],
    dependencies: [
        .package(product: "SnapKit")
    ]
)

let snapKitURL = "https://github.com/SnapKit/SnapKit.git"
let snapKitVersion: Package.Requirement = .exact("5.7.1")

let project = Project(
    name: projectName,
    organizationName: "Page",
    packages: [
        .remote(url: snapKitURL, requirement: snapKitVersion)
    ],
    targets: [target]
)
