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
        .package(path: "../Wizard"),
        .package(path: "../Receive"),
        .package(path: "../Send"),
        .package(path: "../Sheet"),
        .package(path: "../Transaction"),
        .package(path: "../QRScanner")
    ],
    targets: [
        .target(
            name: "Routing",
            dependencies: [
                .product(name: "Main", package: "Main"),
                .product(name: "WizardInfo", package: "Wizard"),
                .product(name: "WizardMnemonicInput", package: "Wizard"),
                .product(name: "WizardMnemonic", package: "Wizard"),
                .product(name: "WizardPasscode", package: "Wizard"),
                .product(name: "WizardBiometric", package: "Wizard"),
                .product(name: "WizardState", package: "Wizard"),
                .product(name: "WizardInitial", package: "Wizard"),
                .product(name: "Receive", package: "Receive"),
                .product(name: "SendState", package: "Send"),
                .product(name: "SendAddress", package: "Send"),
                .product(name: "SendAmount", package: "Send"),
                .product(name: "SendConfirm", package: "Send"),
                .product(name: "SendCompletion", package: "Send"),
                .product(name: "Sheet", package: "Sheet"),
                .product(name: "Transaction", package: "Transaction"),
                .product(name: "QRScanner", package: "QRScanner")
            ],
            path: "Sources/"
        )
    ]
)
