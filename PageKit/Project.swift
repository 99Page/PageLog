//
//  Project.swift
//
//  Created by 노우영 on 8/18/24.
//

import ProjectDescription

let projectName = "PageKit"

let target = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "com.page.pageKit",
    deploymentTargets: .iOS("17.0"),
    sources: ["Sources/**"],
    resources: ["../Resource/Resources/**"],
    dependencies: [
        .package(product: "Kingfisher"),
        .package(product: "SnapKit"),
        .package(product: "ComposableArchitecture"),
        .package(product: "Testing"),
    ],
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "MAU8HFALP8"
        ]
    )
)

let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.page.pageKit.tests",
    deploymentTargets: .iOS("17.0"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: projectName)
    ]
)

let project = Project(
    name: projectName,
    organizationName: "Page",
    packages: [
        .remote(
            url: "https://github.com/onevcat/Kingfisher.git",
            requirement: .upToNextMajor(from: "8.6.0")
        ),
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.7.1")
        ),
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            requirement: .upToNextMajor(from: "1.22.3")
        ),
        /// Xcode26부터 모든 모듈의 인터페이스를 명시적으로 스캔해서 빌드 성능과 안정성을 높혔다.
        /// 따라서 Testing도 명시적으로 의존해줘야한다.
        /// 이 설정은 SWIFT_ENBALE_EXPLICIT_MODULES 에서 확인할 수 있다.
        .remote(
            url: "https://github.com/swiftlang/swift-testing.git",
            requirement: .exact("6.1.3") // swify-syntax 충돌 문제로 현재 나와있는 6.2 버전 사용 불가
                                         // 2025. 10. 10
        )
    ],
    targets: [target, testTarget],
)
