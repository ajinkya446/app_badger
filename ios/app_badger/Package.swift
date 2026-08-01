// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "app-badger",
    products: [
        .library(
            name: "app-badger",
            targets: ["app_badger"]
        ),
    ],
    dependencies: [
        .package(
            name: "FlutterFramework",
            url: "https://github.com/flutter/engine",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    targets: [
        .target(
            name: "app_badger",
            dependencies: [
                .product(name: "Flutter", package: "FlutterFramework"),
            ],
            path: "Sources/app_badger"
        ),
    ]
)
