// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnimationView",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AnimationView",
            targets: ["AnimationView"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/GZIP.git", exact: "1.3.0")
    ],
    targets: [
        .target(
            name: "AnimationView",
            dependencies: [
                "RLottieAnimation"
            ],
            path: "Sources/AnimationView"
        ),
        .target(
            name: "RLottieAnimation",
            dependencies: [
                "RLottie",
                .product(name: "GZIP", package: "GZIP")
            ],
            path: "Sources/RLottieAnimation"
        ),
        .binaryTarget(
            name: "RLottie",
            path: "Frameworks/RLottie.xcframework"
        )
    ]
)
