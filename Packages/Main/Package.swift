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
        .package(path: "../SwiftUIUtils")
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: [
                .product(name: "SwiftUIBackports", package: "SwiftUIUtils"),
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils")
            ],
            path: "Sources/"
        )
    ]
)
