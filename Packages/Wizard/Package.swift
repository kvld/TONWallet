// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wizard",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "WizardBiometric",
            targets: ["WizardBiometric"]
        ),
        .library(
            name: "WizardInfo",
            targets: ["WizardInfo"]
        ),
        .library(
            name: "WizardMnemonic",
            targets: ["WizardMnemonic"]
        ),
        .library(
            name: "WizardMnemonicInput",
            targets: ["WizardMnemonicInput"]
        ),
        .library(
            name: "WizardPasscode",
            targets: ["WizardPasscode"]
        ),
        .library(
            name: "WizardState",
            targets: ["WizardState"]
        ),
        .library(
            name: "WizardInitial",
            targets: ["WizardInitial"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../AnimationView"),
        .package(path: "../Services")
    ],
    targets: [
        .target(
            name: "WizardBiometric",
            dependencies: [
                .product(name: "Components", package: "Components"),
                "WizardState"
            ],
            path: "Sources/Biometric"
        ),
        .target(
            name: "WizardInfo",
            dependencies: [
                .product(name: "Components", package: "Components"),
                .product(name: "AnimationView", package: "AnimationView"),
                "WizardState"
            ],
            path: "Sources/Info"
        ),
        .target(
            name: "WizardMnemonic",
            dependencies: [
                .product(name: "Components", package: "Components"),
                .product(name: "AnimationView", package: "AnimationView"),
                "WizardState"
            ],
            path: "Sources/Mnemonic"
        ),
        .target(
            name: "WizardMnemonicInput",
            dependencies: [
                .product(name: "Components", package: "Components"),
                .product(name: "AnimationView", package: "AnimationView"),
                "WizardState"
            ],
            path: "Sources/MnemonicInput"
        ),
        .target(
            name: "WizardPasscode",
            dependencies: [
                .product(name: "Components", package: "Components"),
                .product(name: "AnimationView", package: "AnimationView"),
                "WizardState"
            ],
            path: "Sources/Passcode"
        ),
        .target(
            name: "WizardState",
            dependencies: [
                .product(name: "TON", package: "Services"),
                .product(name: "CommonServices", package: "Services")
            ],
            path: "Sources/State"
        ),
        .target(
            name: "WizardInitial",
            dependencies: [
                "WizardState",
                "WizardInfo"
            ],
            path: "Sources/Initial"
        ),
    ]
)
