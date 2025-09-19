// swift-tools-version:5.10

import PackageDescription

let iOSPlatforms: [Platform] = [.iOS, .visionOS, .macCatalyst]
let macOSPlatforms: [Platform] = [.macOS]

let swiftSettings: [SwiftSetting] = [
    .unsafeFlags([
        // Per https://forums.swift.org/t/warnings-as-errors-in-sub-packages/70810
        // Having this flag enabled in a sub-package causes conflicts with the
        // automatic "-suppress-warnings" flag added by Xcode.
        //"-warnings-as-errors"
    ])
]

let targets: [Target] = [
    .target(
        name: "FluentUI",
        dependencies: [
            .targetItem(name: "FluentUI_ios", condition: .when(platforms: iOSPlatforms)),
            .targetItem(name: "FluentUI_macos", condition: .when(platforms: macOSPlatforms))
        ],
        path: "Sources/FluentUI",
        swiftSettings: swiftSettings
    ),
    .target(
        name: "FluentUI_ios",
        dependencies: [
            .target(name: "FluentUI_common")
        ],
        path: "Sources/FluentUI_iOS",
        resources: [
            .copy("Resources/Version.plist")
        ],
        swiftSettings: swiftSettings
    ),
    .target(
        name: "FluentUI_macos",
        dependencies: [
            .target(name: "FluentUI_common")
        ],
        path: "Sources/FluentUI_macOS",
        swiftSettings: swiftSettings
    ),
    .target(
        name: "FluentUI_common",
        path: "Sources/FluentUI_common",
        swiftSettings: swiftSettings
    )
]
let testTargets: [Target] = [
    .testTarget(
        name: "FluentUI_iOS_Tests",
        dependencies: [
            .target(name: "FluentUI_ios", condition: .when(platforms: iOSPlatforms)),
        ],
        path: "Tests/FluentUI_iOS_Tests",
        swiftSettings: swiftSettings
    ),
    .testTarget(
        name: "FluentUI_macOS_Tests",
        dependencies: [
            .target(name: "FluentUI_macos", condition: .when(platforms: macOSPlatforms))
        ],
        path: "Tests/FluentUI_macOS_Tests",
        swiftSettings: swiftSettings
    )
]

let package = Package(
    name: "FluentUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
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
