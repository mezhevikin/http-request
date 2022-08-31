// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "HttpRequest",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "HttpRequest",
            targets: ["HttpRequest"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "HttpRequest",
            dependencies: []),
        .testTarget(
            name: "HttpRequestTests",
            dependencies: ["HttpRequest"]),
    ]
)
