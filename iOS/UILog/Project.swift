//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 10/29/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

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

let projectName = "UILog"

let target = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .app,
    bundleId: "com.rim.ui.log",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../Resource/Resources/**"],
    dependencies: [
        .project(target: "PageKit", path: .relativeToRoot("PageKit")),
    ],
    settings: .default
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.rim.ui.log.tests",
    deploymentTargets: .iOS("17.0"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: projectName)
    ],
    settings: .default
)


let project = Project(
    name: projectName,
    organizationName: "Page",
    packages: [
    ],
    settings: nil,
    targets: [target, testTarget]
)


