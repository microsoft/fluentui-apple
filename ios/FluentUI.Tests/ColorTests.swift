//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import FluentUI

class ColorTests: XCTestCase {

    func testColorsExist() throws {
        for paletteColor in Colors.Palette.allCases {
            XCTAssertNotNil(paletteColor.color)
        }
    }

    /// Validates that the background and foreground colors for a given index of the Colors.avatarColors property match comparing:
    ///  1. A color light mode background color with its counterpart dark mode foreground color. The color should be the same (tint40)
    ///  2. A color light mode foreground color with its counterpart dark mode background color. The color should be the same (shade30)
    ///
    /// Text calculated colors are defined as the following for a given color:
    ///  - Light mode:
    ///    - Background: tint40
    ///    - Foreground: shade30
    ///  - Dark mode:
    ///    - Background: shade30
    ///    - Foreground: tint40
    func testAvatarColorsMatch() {
        let lightModeTraitCollection = UITraitCollection(userInterfaceStyle: .light)
        let darkModeTraitCollection = UITraitCollection(userInterfaceStyle: .dark)

        let backgroundColors = FluentUIThemeManager.defaultTheme().MSFAvatarTokens.textCalculatedBackgroundColors
        let foregroundColors = FluentUIThemeManager.defaultTheme().MSFAvatarTokens.textCalculatedForegroundColors

        for (index, bgColor) in backgroundColors.enumerated() {
            let fgColor = foregroundColors[index]
            let bgLightColor = bgColor.resolvedColor(with: lightModeTraitCollection)
            let bgDarkColor = bgColor.resolvedColor(with: darkModeTraitCollection)
            let fgLightColor = fgColor.resolvedColor(with: lightModeTraitCollection)
            let fgDarkColor = fgColor.resolvedColor(with: darkModeTraitCollection)

            XCTAssertEqual(bgLightColor,
                           fgDarkColor,
                           "Index \(index): Background color in light mode does not match Foreground color in dark mode.")

            XCTAssertEqual(bgDarkColor,
                           fgLightColor,
                           "Index \(index): Background color in dark mode does not match Foreground color in light mode.")
        }
    }

    func testColorValue() {
        let hexColorValue = ColorValue(0xC7E0F4)
        XCTAssertEqual(hexColorValue.a, 1.0)
        XCTAssertEqual(hexColorValue.r, CGFloat(0xC7) / 255.0)
        XCTAssertEqual(hexColorValue.g, CGFloat(0xE0) / 255.0)
        XCTAssertEqual(hexColorValue.b, CGFloat(0xF4) / 255.0)

        let rgbaColorValue = ColorValue(r: 0.35, g: 1.0, b: 0.82, a: 0.75)
        XCTAssertEqual(rgbaColorValue.a, 0.75, accuracy: 0.01)
        XCTAssertEqual(rgbaColorValue.r, 0.35, accuracy: 0.01)
        XCTAssertEqual(rgbaColorValue.g, 1.0, accuracy: 0.01)
        XCTAssertEqual(rgbaColorValue.b, 0.82, accuracy: 0.01)
    }

    func testColorValueConversions() {
        let colorValue = ColorValue(r: 0.35, g: 1.0, b: 0.82, a: 0.75)
        let color = UIColor(colorValue: colorValue)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        // Verify that UIColor's getters return the same values as ColorValue's
        XCTAssertTrue(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        XCTAssertEqual(colorValue.a, alpha)
        XCTAssertEqual(colorValue.r, red)
        XCTAssertEqual(colorValue.g, green)
        XCTAssertEqual(colorValue.b, blue)
    }
}
