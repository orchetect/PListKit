// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "PListKit",
	
	platforms: [
		.macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
	],
	
    products: [
		
        .library(
            name: "PListKit",
            targets: ["PListKit"])
		
    ],
	
    dependencies: [
		
        // Main target dependencies:
		// (none)
		
		// Test target dependencies:
		.package(url: "https://github.com/orchetect/OTCore", from: "1.1.3")
		
    ],
	
    targets: [
        
		// Main module
        .target(
            name: "PListKit",
            dependencies: []),
		
		// Unit tests
        .testTarget(
            name: "PListKitTests",
            dependencies: ["PListKit", "OTCore"])
		
    ]
	
)
