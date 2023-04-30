// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QRUtils",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "QRUtils",
            targets: ["QRUtils"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/fwcd/swift-qrcode-generator.git", exact: "1.0.3")
    ],
    targets: [
        .target(
            name: "QRUtils",
            dependencies: [
                .product(name: "QRCodeGenerator", package: "swift-qrcode-generator")
            ],
            path: "Sources/"
        )
    ]
)
