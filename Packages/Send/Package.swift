// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Send",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SendState",
            targets: ["SendState"]
        ),
        .library(
            name: "SendAddress",
            targets: ["SendAddress"]
        ),
        .library(
            name: "SendAmount",
            targets: ["SendAmount"]
        ),
        .library(
            name: "SendConfirm",
            targets: ["SendConfirm"]
        ),
        .library(
            name: "SendCompletion",
            targets: ["SendCompletion"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../SwiftUIUtils"),
        .package(path: "../AnimationView"),
        .package(path: "../Services")
    ],
    targets: [
        .target(
            name: "SendAddress",
            dependencies: [
                "SendState",
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "Components", package: "Components")
            ],
            path: "Sources/Address"
        ),
        .target(
            name: "SendAmount",
            dependencies: [
                "SendState",
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "Components", package: "Components")
            ],
            path: "Sources/Amount"
        ),
        .target(
            name: "SendConfirm",
            dependencies: [
                "SendState",
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "Components", package: "Components")
            ],
            path: "Sources/Confirm"
        ),
        .target(
            name: "SendState",
            dependencies: [
                .product(name: "TON", package: "Services"),
                .product(name: "CommonServices", package: "Services")
            ],
            path: "Sources/State"
        ),
        .target(
            name: "SendCompletion",
            dependencies: [
                "SendState",
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "Components", package: "Components"),
                .product(name: "AnimationView", package: "AnimationView")
            ],
            path: "Sources/Completion"
        )
    ]
)
