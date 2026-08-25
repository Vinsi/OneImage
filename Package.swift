// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let packageDir = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path

let package = Package(
    name: "ImageIO",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Core",
            targets: ["Core"]
        ),
        .library(
            name: "View",
            targets: ["View"]
        ),
        .library(
            name: "ImageIOSampleUI",
            targets: ["ImageIOSampleUI"]
        ),
        .executable(
            name: "ImageIOSample",
            targets: ["ImageIOSample"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Core"
        ),
        .target(
            name: "View",
            dependencies: [
                "Core"
            ]
        ),
        .target(
            name: "ImageIOSampleUI",
            dependencies: ["View"]
        ),
        .executableTarget(
            name: "ImageIOSample",
            dependencies: ["ImageIOSampleUI"],
            exclude: ["Info.plist"],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "\(packageDir)/Sources/ImageIOSample/Info.plist",
                ])
            ]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        ),
        .testTarget(
            name: "ViewUITests",
            dependencies: ["View"]
        ),
    ]
)
