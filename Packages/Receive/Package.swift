// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Receive",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Receive",
            targets: ["Receive"]
        ),
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../SwiftUIUtils"),
        .package(path: "../QRUtils"),
        .package(path: "../Services")
    ],
    targets: [
        .target(
            name: "Receive",
            dependencies: [
                .product(name: "Components", package: "Components"),
                .product(name: "SwiftUIHelpers", package: "SwiftUIUtils"),
                .product(name: "QRUtils", package: "QRUtils"),
                .product(name: "TON", package: "Services")
            ],
            path: "Sources/"
        )
    ]
)
