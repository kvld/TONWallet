// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Storage",
            targets: ["Storage"]
        ),
        .library(
            name: "TON",
            targets: ["TON"]
        ),
        .library(
            name: "CommonServices",
            targets: ["CommonServices"]
        )
    ],
    dependencies: [
        .package(path: "../TONKit")
    ],
    targets: [
        .target(
            name: "Storage",
            dependencies: [],
            path: "Sources/Storage"
        ),
        .target(
            name: "TON",
            dependencies: [
                .product(name: "Mnemonic", package: "TONKit"),
                .product(name: "TONClient", package: "TONKit"),
                .product(name: "TONSchema", package: "TONKit"),
                .product(name: "BOC", package: "TONKit"),
                "Storage"
            ],
            path: "Sources/TON"
        ),
        .target(
            name: "CommonServices",
            dependencies: [
                "TON"
            ],
            path: "Sources/Common"
        )
    ]
)
