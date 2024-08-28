import ProjectDescription

let projectName = "TimeComplexity"

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let target = Target.target(
    name: projectName,
    destinations: .macOS,
    product: .staticFramework,
    bundleId: "com.page.language.time.complexity",
    deploymentTargets: .macOS("14.5"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"]
)


let testTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .macOS,
    product: .unitTests,
    bundleId: "com.page.language.time.complexity.tests",
    deploymentTargets: .macOS("14.5"),
    sources: ["Tests/**"],
    dependencies: [
        .target(name: projectName)
    ]
)


let project = Project(
    name: projectName,
    organizationName: "Page",
    targets: [target, testTarget]
)




