// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HandleFileTool",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        
        .executable(name: "HandleFileTool", targets: ["HandleFileTool"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.4"),
        .package(url: "https://github.com/570262616/CommandLine", from: "5.0.4"),
        .package(url: "https://github.com/kylef/Spectre.git", from: "0.8.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "HandleFileTool",
            dependencies: ["Rainbow", "PathKit", "CommandLine"]),
        .testTarget(
            name: "HandleFileToolTests",
            dependencies: ["HandleFileTool", ]),
    ]
)
