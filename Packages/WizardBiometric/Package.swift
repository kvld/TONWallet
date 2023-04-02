// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WizardBiometric",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "WizardBiometric",
            targets: ["WizardBiometric"]
        ),
    ],
    dependencies: [
        .package(path: "../Components")
    ],
    targets: [
        .target(
            name: "WizardBiometric",
            dependencies: [
                .product(name: "Components", package: "Components")
            ],
            path: "Sources/"
        )
    ]
)
