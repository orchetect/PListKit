// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "PListKit",
	
	platforms: [
		.macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
	],
	
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PListKit",
            targets: ["PListKit"])
    ],
	
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/orchetect/OTCore", from: "1.0.3")
    ],
	
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PListKit",
            dependencies: []),
        .testTarget(
            name: "PListKitTests",
            dependencies: ["PListKit", "OTCore"])
    ]
	
)