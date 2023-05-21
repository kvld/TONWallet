// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Passcode",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Passcode",
            targets: ["Passcode"]
        ),
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../Services")
    ],
    targets: [
        .target(
            name: "Passcode",
            dependencies: [
                .product(name: "Components", package: "Components"),
                .product(name: "CommonServices", package: "Services")
            ],
            path: "Sources/"
        )
    ]
)
