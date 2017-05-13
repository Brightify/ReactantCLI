// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "ReactantCLI",
    targets: [
        Target(
            name: "reactant",
            dependencies: [

            ]
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/jakeheis/SwiftCLI", majorVersion: 3, minor: 0),
        .Package(url: "https://github.com/onevcat/Rainbow", majorVersion: 2),
        .Package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", "0.5.0")
    ]
)
