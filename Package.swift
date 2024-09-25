// swift-tools-version:5.9

import PackageDescription

let iOSPlatforms: [Platform] = [.iOS, .visionOS, .macCatalyst]
let macOSPlatforms: [Platform] = [.macOS]

let targets: [Target] = [
    .target(
        name: "FluentUI",
        dependencies: [
            .targetItem(name: "FluentUI_ios", condition: .when(platforms: iOSPlatforms)),
            .targetItem(name: "FluentUI_macos", condition: .when(platforms: macOSPlatforms))
        ],
        path: "Sources/FluentUI"
    ),
    .target(
        name: "FluentUI_ios",
        path: "Sources/FluentUI_iOS",
        resources: [
            .copy("Resources/Version.plist")
        ]
    ),
    .target(
        name: "FluentUI_macos",
        path: "Sources/FluentUI_macOS"
    )
]

let testTargets: [Target] = [
    .testTarget(
        name: "FluentUI_iOS_Tests",
        dependencies: [
            .target(name: "FluentUI_ios", condition: .when(platforms: iOSPlatforms)),
        ],
        path: "Tests/FluentUI_iOS_Tests"
    ),
    .testTarget(
        name: "FluentUI_macOS_Tests",
        dependencies: [
            .target(name: "FluentUI_macos", condition: .when(platforms: macOSPlatforms))
        ],
        path: "Tests/FluentUI_macOS_Tests"
    )
]

let package = Package(
    name: "FluentUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "FluentUI",
            type: .static,
            targets: [
                "FluentUI"
            ]
        )
    ],
    targets: targets + testTargets
)
