// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MessageStackView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MessageStackView",
            targets: ["MessageStackView", "MessageStackViewObjC"]
        )
    ],
    targets: [
        .target(
            name: "MessageStackView",
            dependencies: ["MessageStackViewObjC"],
            path: "Sources/Swift"
        ),
        .testTarget(
            name: "MessageStackViewTests",
            dependencies: ["MessageStackView"]
        ),
        .target(
            name: "MessageStackViewObjC",
            dependencies: [],
            path: "Sources/ObjectiveC",
            publicHeadersPath: "include"
            )
    ]
)
