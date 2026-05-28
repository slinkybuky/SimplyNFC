// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimplyNFC",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(
            name: "SimplyNFC",
            targets: ["SimplyNFC"]),
        .executable(
            name: "SimplyNFCApp",
            targets: ["SimplyNFCApp"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "SimplyNFC",
            dependencies: []),
        .target(
            name: "SimplyNFCApp",
            dependencies: ["SimplyNFC"],
            path: "Sources/SimplyNFCApp",
            resources: [
                .process("Info.plist")
            ]),
        .testTarget(
            name: "SimplyNFCTests",
            dependencies: ["SimplyNFC"]),
    ]
)
