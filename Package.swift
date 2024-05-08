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

func addShouldTestFlag() {
    package.targets.filter(\.isTest).forEach { target in
        if target.swiftSettings == nil { target.swiftSettings = [] }
        target.swiftSettings?.append(.define("shouldTestCurrentPlatform"))
    }
}

// Xcode 12.5.1 (Swift 5.4.2) introduced watchOS testing
#if swift(>=5.4.2)
addShouldTestFlag()
#elseif !os(watchOS)
addShouldTestFlag()
#endif
