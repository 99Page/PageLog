//
//  Project.swift
//  2023KakaoManifests
//
//  Created by Reppley_iOS on 4/21/25.
//

import Foundation
import ProjectDescription

let projectName = "CaseStudies-UIKit"

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": true,
        "UISceneConfigurations": [
            // SceneDelegate가 동작하기 위해 필요한 키 값입니다.
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ]
            ]
        ]
    ]
]


let target = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.ui.case-studies-uikit",
    deploymentTargets: .iOS("18.0"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../Resource/Resources/**"],
    dependencies: [
        .package(product: "SnapKit"),
    ]
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.ui.case-studies-uikit.test",
    deploymentTargets: .iOS("18.0"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: projectName)
    ]
)

let snapKitURL = "https://github.com/SnapKit/SnapKit.git"
let snapKitVersion: Package.Requirement = .exact("5.7.1")

let project = Project(
    name: projectName,
    organizationName: "Page",
    packages: [
        .remote(url: snapKitURL, requirement: snapKitVersion),
    ],
    targets: [target, testTarget]
)
