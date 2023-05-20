// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Settings",
            targets: ["Settings"]
        ),
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../SwiftUIUtils")
    ],
    targets: [
        .target(
            name: "Settings",
            dependencies: [
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "Components", package: "Components")
            ],
            path: "Sources/"
        )
    ]
)
