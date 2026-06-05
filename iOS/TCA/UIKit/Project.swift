//
//  Project.swift
//  2023KakaoManifests
//
//  Created by 노우영 on 1/14/25.
//

import Foundation
import ProjectDescription

let projectName = "CaseStudies-TCA-UIKit"

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
    bundleId: "com.page.case.studies.uikit",
    deploymentTargets: .iOS("18.0"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../Resource/Resources/**"],
    dependencies: [
        .package(product: "MessageKit"),
        .package(product: "Starscream"),
        .project(target: "PageKit", path: .relativeToRoot("PageKit"))
    ]
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.tca.uikit",
    deploymentTargets: .iOS("18.0"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: projectName)
    ]
)

let messageKitURL = "https://github.com/MessageKit/MessageKit.git"
let messageVersion: Package.Requirement = .exact("5.0.0")

let starscreamURL = "https://github.com/daltoniam/Starscream.git"
let starscreamVersion: Package.Requirement = .exact("4.0.8")

let project = Project(
    name: projectName,
    organizationName: "Page",
    packages: [
        .remote(url: messageKitURL, requirement: messageVersion),
        .remote(url: starscreamURL, requirement: starscreamVersion),
    ],
    targets: [target, testTarget]
)
