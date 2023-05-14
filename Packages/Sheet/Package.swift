// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sheet",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Sheet",
            targets: ["Sheet"]
        ),
    ],
    dependencies: [
        .package(path: "../Components")
    ],
    targets: [
        .target(
            name: "Sheet",
            dependencies: [
                "Support",
                .product(name: "Components", package: "Components")
            ],
            path: "Sources/"
        ),
        .target(
            name: "Support",
            dependencies: [],
            path: "Support/"
        )
    ]
)
