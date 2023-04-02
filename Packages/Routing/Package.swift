// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Routing",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Routing",
            targets: ["Routing"]
        ),
    ],
    dependencies: [
        .package(path: "../Main"),

        .package(path: "../WizardInfo"),
        .package(path: "../WizardMnemonicInput"),
        .package(path: "../WizardMnemonic"),
        .package(path: "../WizardPasscode"),
        .package(path: "../WizardBiometric"),
    ],
    targets: [
        .target(
            name: "Routing",
            dependencies: [
                .product(name: "Main", package: "Main"),
                .product(name: "WizardInfo", package: "WizardInfo"),
                .product(name: "WizardMnemonicInput", package: "WizardMnemonicInput"),
                .product(name: "WizardMnemonic", package: "WizardMnemonic"),
                .product(name: "WizardPasscode", package: "WizardPasscode"),
                .product(name: "WizardBiometric", package: "WizardBiometric"),
            ],
            path: "Sources/"
        )
    ]
)
