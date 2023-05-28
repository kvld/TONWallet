// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TONKit",
    platforms: [.iOS(.v14), .macOS(.v12)],
    products: [
        .library(
            name: "TONClient",
            targets: ["TONClient"]
        ),
        .library(
            name: "TONSchema",
            targets: ["TONSchema"]
        ),
        .library(
            name: "BOC",
            targets: ["BOC"]
        ),
        .executable(
            name: "TONSchemaGenerator",
            targets: ["TONSchemaGenerator"]
        )
    ],
    targets: [
        .target(
            name: "TONClient",
            dependencies: [
                "TONLibJSON",
                "TONSchema"
            ],
            path: "Sources/Client"
        ),
        .target(
            name: "TONSchema",
            dependencies: [],
            path: "Sources/Schema"
        ),
        .target(
            name: "BOC",
            dependencies: [],
            path: "Sources/BOC"
        ),
        .executableTarget(
            name: "TONSchemaGenerator",
            dependencies: [],
            path: "Sources/SchemaGenerator"
        ),
        .binaryTarget(
            name: "TONLibJSON",
            path: "Frameworks/TONLibJSON.xcframework"
        )
    ]
)
