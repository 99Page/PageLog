import ProjectDescription

let identifier = "2023.kakao"

let target = Target.target(
    name: identifier,
    destinations: .macOS,
    product: .commandLineTool,
    bundleId: "com.page.programmers.\(identifier)",
    deploymentTargets: .macOS("14.5"),
    sources: ["Sources/**"]
)

let project = Project(
    name: "\(identifier)",
    organizationName: "Page",
    targets: [target]
)




