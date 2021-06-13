// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Filters",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Filters",
            targets: ["Filters"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "../Domain", from: "1.0.0"),
        .package(url: "../SwiftUtils", from: "1.0.0"),
        .package(url: "../SwiftUIUtils", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Filters",
            dependencies: ["Domain", "SwiftUtils", "SwiftUIUtils"]
        ),
        .testTarget(
            name: "FiltersTests",
            dependencies: ["Filters"]
        )
    ]
)
