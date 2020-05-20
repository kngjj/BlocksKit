// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "BlocksKit",
    products: [
        .library(name: "BlocksKit", targets: ["BlocksKit"]),
    ],
    targets: [
        .target(name: "BlocksKit", dependencies: []),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
