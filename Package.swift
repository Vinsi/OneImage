// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let packageDir = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path

let package = Package(
    name: "OneImage",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OneImageCore",
            targets: ["OneImageCore"]
        ),
        .library(
            name: "OneImageView",
            targets: ["OneImageView"]
        ),
        .library(
            name: "OneImageSampleUI",
            targets: ["OneImageSampleUI"]
        ),
        .executable(
            name: "OneImageSample",
            targets: ["OneImageSample"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OneImageCore"
        ),
        .target(
            name: "OneImageView",
            dependencies: [
                "OneImageCore"
            ]
        ),
        .target(
            name: "OneImageSampleUI",
            dependencies: [
                "OneImageView",
                .product(name: "Kingfisher", package: "Kingfisher"),
            ]
        ),
        .executableTarget(
            name: "OneImageSample",
            dependencies: ["OneImageSampleUI"],
            exclude: ["Info.plist"],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "\(packageDir)/Sources/OneImageSample/Info.plist",
                ])
            ]
        ),
        .testTarget(
            name: "OneImageCoreTests",
            dependencies: ["OneImageCore"]
        ),
        .testTarget(
            name: "OneImageViewUITests",
            dependencies: ["OneImageView"]
        ),
    ]
)
