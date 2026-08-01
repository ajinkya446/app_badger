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
    targets: [
        .target(
            name: "app_badger",
            dependencies: [],
            path: "../Classes"
        ),
    ]
)
