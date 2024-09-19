import ProjectDescription

let problemNumber = "gold-platinum-solver"
let target = Target.target(
    name: problemNumber,
    destinations: .macOS,
    product: .commandLineTool,
    bundleId: "com.page.backjoon.gold.platinum.solver",
    deploymentTargets: .macOS("14.5"),
    sources: ["Sources/**"]
)

let project = Project(
    name: "\(problemNumber)",
    organizationName: "Page",
    targets: [target]
)







