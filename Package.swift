// swift-tools-version:5.5
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "PListKit",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "PListKit",
            targets: ["PListKit"]
        )
    ],
    targets: [
        .target(
            name: "PListKit",
            dependencies: []
        ),
        .testTarget(
            name: "PListKitTests",
            dependencies: ["PListKit"]
        )
    ]
)
