import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "Launch Screen",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light", // 다크 모드를 사용하지 않습니다.
]


let pageResourceTarget = Target.target(
    name: "PageResources",
    destinations: .iOS,
    product: .framework,
    bundleId: "com.page.page.component",
    deploymentTargets: .iOS("17.4"),
    infoPlist: .extendingDefault(with: infoPlist),
    resources: ["Resources/**"]
)

let project = Project(
    name: "PageResource",
    organizationName: "Page",
    settings: nil,
    targets: [pageResourceTarget]
)



