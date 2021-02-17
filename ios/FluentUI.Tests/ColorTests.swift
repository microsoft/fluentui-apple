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

        for (index, colorSet) in Colors.avatarColors.enumerated() {
            let bgColor = colorSet.background
            let fgColor = colorSet.foreground
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
