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
        .package(path: "../Services")
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: [
                .product(name: "SwiftUIBackports", package: "SwiftUIUtils"),
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "TON", package: "Services")
            ],
            path: "Sources/"
        )
    ]
)
