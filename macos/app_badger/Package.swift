// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "app_badger",
    platforms: [
        .macOS("10.14"),
    ],
    products: [
        .library(name: "app-badger", targets: ["app_badger"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "app_badger",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: []
        ),
    ]
)
