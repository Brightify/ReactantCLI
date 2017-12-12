// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ReactantCLI",
    products: [
        .library(name: "ProjectGenerator", targets: ["ProjectGeneratorFramework"]),
        .executable(name: "reactant", targets: ["reactant"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", .upToNextMinor(from: "4.0.0")),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMinor(from: "3.0.0")),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", from: "0.8.0"),
    ],
    targets: [
        .target(name: "ProjectGeneratorFramework"),
        .target(name: "reactant", dependencies: [
            "SwiftCLI",
            "Rainbow",
            "SwiftyTextTable",
            .target(name: "ProjectGeneratorFramework"),
        ]),
        .testTarget(name: "ReactantCLITests", dependencies: [
            ]),
    ]
)
