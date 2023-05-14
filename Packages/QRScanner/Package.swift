// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QRScanner",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "QRScanner",
            targets: ["QRScanner"]
        ),
    ],
    dependencies: [
        .package(path: "../Components")
    ],
    targets: [
        .target(
            name: "QRScanner",
            dependencies: [
                .product(name: "Components", package: "Components")
            ],
            path: "Sources/"
        )
    ]
)
