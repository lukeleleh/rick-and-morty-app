// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "RickAndMortyPackage",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "CharacterDetail", targets: ["CharacterDetail"]),
        .library(name: "CharacterList", targets: ["CharacterList"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "EpisodeDetail", targets: ["EpisodeDetail"]),
        .library(name: "EpisodeList", targets: ["EpisodeList"]),
        .library(name: "Filters", targets: ["Filters"]),
        .library(name: "LocationDetail", targets: ["LocationDetail"]),
        .library(name: "LocationList", targets: ["LocationList"]),
        .library(name: "Network", targets: ["Network"]),
        .library(name: "RickAndMortyAPI", targets: ["RickAndMortyAPI"]),
        .library(name: "SwiftUIUtils", targets: ["SwiftUIUtils"]),
        .library(name: "SwiftUtils", targets: ["SwiftUtils"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CharacterDetail",
            dependencies: ["Network", "SwiftUtils", "SwiftUIUtils", "Domain"]
        ),
        .testTarget(name: "CharacterDetailTests", dependencies: ["CharacterDetail"]),

        .target(
            name: "CharacterList",
            dependencies: ["Network", "SwiftUIUtils", "Domain", "RickAndMortyAPI"]
        ),
        .testTarget(name: "CharacterListTests", dependencies: ["CharacterList"]),

        .target(name: "Domain", dependencies: []),
        .testTarget(name: "DomainTests", dependencies: ["Domain"]),

        .target(
            name: "EpisodeDetail",
            dependencies: ["Network", "SwiftUtils", "SwiftUIUtils", "Domain"]
        ),
        .testTarget(name: "EpisodeDetailTests", dependencies: ["EpisodeDetail"]),

        .target(
            name: "EpisodeList",
            dependencies: ["Network", "SwiftUIUtils", "Domain", "RickAndMortyAPI"]
        ),
        .testTarget(name: "EpisodeListTests", dependencies: ["EpisodeList"]),

        .target(
            name: "Filters",
            dependencies: ["Domain", "SwiftUtils", "SwiftUIUtils"]
        ),
        .testTarget(name: "FiltersTests", dependencies: ["Filters"]),

        .target(
            name: "LocationDetail",
            dependencies: ["Network", "SwiftUtils", "SwiftUIUtils", "Domain"]
        ),
        .testTarget(name: "LocationDetailTests", dependencies: ["LocationDetail"]),

        .target(
            name: "LocationList",
            dependencies: ["Network", "SwiftUtils", "SwiftUIUtils", "Domain", "RickAndMortyAPI"]
        ),
        .testTarget(name: "LocationListTests", dependencies: ["LocationList"]),

        .target(name: "Network", dependencies: []),
        .testTarget(name: "NetworkTests", dependencies: ["Network"]),

        .target(name: "RickAndMortyAPI", dependencies: []),
        .testTarget(name: "RickAndMortyAPITests", dependencies: ["RickAndMortyAPI"]),

        .target(name: "SwiftUIUtils", dependencies: []),
        .testTarget(name: "SwiftUIUtilsTests", dependencies: ["SwiftUIUtils"]),

        .target(name: "SwiftUtils", dependencies: []),
        .testTarget(name: "SwiftUtilsTests",dependencies: ["SwiftUtils"])
    ]
)
