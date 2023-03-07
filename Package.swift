// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swift-command-shell",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.2.2"))
    ],
    targets: [
        .executableTarget(
            name: "swift-command-shell",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)
