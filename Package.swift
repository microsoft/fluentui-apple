// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "FluentUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15),
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
    targets: [
        .target(
            name: "FluentUI",
            dependencies: [
                .target(name: "FluentUI_ios", condition: .when(platforms: [.iOS])),
                .target(name: "FluentUI_macos", condition: .when(platforms: [.macOS]))
            ],
            path: "public"
        ),
        .target(
            name: "FluentUI_ios",
            path: "ios/FluentUI",
            exclude: [
                "Avatar/Avatar.resources.xcfilelist",
                "BarButtonItems/BarButtonItems.resources.xcfilelist",
                "Bottom Commanding/BottomCommanding.resources.xcfilelist",
                "Core/Core.resources.xcfilelist",
                "HUD/HUD.resources.xcfilelist",
                "Navigation/Navigation.resources.xcfilelist",
                "Notification/Notification.resources.xcfilelist",
                "Other Cells/OtherCells.resources.xcfilelist",
                "Resources/Localization/CultureMapping.json",
                "Table View/TableView.resources.xcfilelist",
                "TextField/TextField.resources.xcfilelist",
                "Tooltip/Tooltip.resources.xcfilelist",
                "TwoLineTitleView/TwoLineTitleView.resources.xcfilelist",
            ]
        ),
        .target(
            name: "FluentUI_macos",
            path: "macos/FluentUI",
            exclude: [
                "FluentUI-Info.plist"
            ]
        )
    ]
)
