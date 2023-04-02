// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Components",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Components",
            targets: ["Components"]
        ),
    ],
    dependencies: [
        .package(path: "../SwiftUIUtils")
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "SwiftUIBackports", package: "SwiftUIUtils")
            ],
            path: "Sources/"
        )
    ]
)
