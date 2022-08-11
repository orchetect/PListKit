// swift-tools-version:5.3

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
    
    dependencies: [
        // none
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
