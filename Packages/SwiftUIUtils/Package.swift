// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIUtils",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SwiftUIBackports",
            targets: ["SwiftUIBackports"]
        ),
        .library(
            name: "SwiftUIHelpers",
            targets: ["SwiftUIHelpers"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIBackports",
            dependencies: [],
            path: "Sources/Backports"
        ),
        .target(
            name: "SwiftUIHelpers",
            dependencies: [],
            path: "Sources/Helpers"
        )
    ]
)
