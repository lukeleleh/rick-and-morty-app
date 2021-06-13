// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationList",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "LocationList",
            targets: ["LocationList"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "../Network", from: "1.0.0"),
        .package(url: "../SwiftUtils", from: "1.0.0"),
        .package(url: "../SwiftUIUtils", from: "1.0.0"),
        .package(url: "../Domain", from: "1.0.0"),
        .package(url: "../RickAndMortyAPI", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "LocationList",
            dependencies: ["Network", "SwiftUtils", "SwiftUIUtils", "Domain", "RickAndMortyAPI"]
        ),
        .testTarget(
            name: "LocationListTests",
            dependencies: ["LocationList"]
        )
    ]
)
