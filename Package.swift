// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "advent-of-code-2024",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-collections/", from: "1.1.4")
    ],
    targets: [
        .executableTarget(
            name: "advent-of-code-2024",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "BitCollections", package: "swift-collections"),
                .product(name: "HashTreeCollections", package: "swift-collections")
            ],
            resources: [
                .process("ExampleInputs/")
            ]
        ),
    ]
)
