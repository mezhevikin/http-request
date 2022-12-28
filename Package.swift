// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "HttpRequest",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4)
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
