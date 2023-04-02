// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WizardMnemonicInput",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "WizardMnemonicInput",
            targets: ["WizardMnemonicInput"]
        ),
    ],
    dependencies: [
        .package(path: "../AnimationView"),
        .package(path: "../Components")
    ],
    targets: [
        .target(
            name: "WizardMnemonicInput",
            dependencies: [
                .product(name: "AnimationView", package: "AnimationView"),
                .product(name: "Components", package: "Components")
            ],
            path: "Sources/"
        )
    ]
)
