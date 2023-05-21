// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Main",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Main",
            targets: ["Main"]
        ),
    ],
    dependencies: [
        .package(path: "../SwiftUIUtils"),
        .package(path: "../Services"),
        .package(path: "../AnimationView")
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: [
                .product(name: "AnimationView", package: "AnimationView"),
                .product(name: "SwiftUIBackports", package: "SwiftUIUtils"),
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "TON", package: "Services"),
                .product(name: "CommonServices", package: "Services")
            ],
            path: "Sources/"
        )
    ]
)
