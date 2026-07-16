// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MessageStackView",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "MessageStackView",
            targets: ["MessageStackView"]
        )
    ],
    targets: [
        .target(
            name: "MessageStackViewObjC",
            path: "Sources/MessageStackViewObjC",
            publicHeadersPath: "include"
        ),
        .target(
            name: "MessageStackView",
            dependencies: ["MessageStackViewObjC"],
            path: "Sources/MessageStackView",
            resources: [
                .process("Theme/Assets.xcassets"),
                .process("Theme/Images.xcassets")
            ]
        ),
        .testTarget(
            name: "MessageStackViewTests",
            dependencies: ["MessageStackView"],
            path: "Tests/MessageStackViewTests"
        )
    ]
)
