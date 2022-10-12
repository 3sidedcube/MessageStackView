// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MessageStackView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "MessageStackView",
            targets: ["MessageStackView"]
        )
    ],
    targets: [
        .target(
            name: "MessageStackView",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "MessageStackViewTests",
            dependencies: ["MessageStackView"]
        )
    ]
)
