//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
import FluentUI

class AvatarTests: XCTestCase {

    /// Validates that the number of colors defined for tokens textCalculatedBackgroundColors and textCalculatedForegroundColors are the same.
    func testTextCalculatedBackgroundForegroundColorsCount() {
        XCTAssertEqual(FluentUIThemeManager.S.MSFAvatarTokens.textCalculatedBackgroundColors.count,
                       FluentUIThemeManager.S.MSFAvatarTokens.textCalculatedForegroundColors.count,
                       "Text calculated background and foreground colors should provide the same number of options.")
    }

    /// Validates that the background and foreground colors for a given index in both arrays (textCalculatedBackgroundColors and textCalculatedForegroundColors tokens) match comparing:
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
    func testTextCalculatedBackgroundForegroundColorsMatch() {
        let bgColors = FluentUIThemeManager.S.MSFAvatarTokens.textCalculatedBackgroundColors
        let fgColors = FluentUIThemeManager.S.MSFAvatarTokens.textCalculatedForegroundColors
        let lightModeTraitCollection = UITraitCollection(userInterfaceStyle: .light)
        let darkModeTraitCollection = UITraitCollection(userInterfaceStyle: .dark)

        for (index, bgColor) in bgColors.enumerated() {
            let fgColor = fgColors[index]
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

}
