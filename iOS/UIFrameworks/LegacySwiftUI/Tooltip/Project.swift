import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let tooltipTarget = Target.target(
    name: "Tooltip",
    destinations: .iOS,
    product: .app,
    bundleId: "com.page.tooltip",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["../../../Resource/Resources/**"]
)

let tooltipProject = Project(
    name: "Tooltip",
    organizationName: "Page",
    targets: [tooltipTarget]
)


