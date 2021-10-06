// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MessageStackView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MessageStackView",
            targets: ["MessageStackView"]
        )
    ],
    dependencies: [
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
