//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import FluentUI

class ColorTests: XCTestCase {

    @available(*, deprecated)
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

    @available(*, deprecated)
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

    func testColorHexValue() {
        let hexValue = UInt32(0xC7E0F4)
        let color = UIColor(hexValue: hexValue)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        // Verify that UIColor's getters return the same values as ColorValue's
        XCTAssertTrue(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        XCTAssertEqual(1.0, alpha)
        XCTAssertEqual(CGFloat(0xC7) / 255.0, red, accuracy: 0.01)
        XCTAssertEqual(CGFloat(0xE0) / 255.0, green, accuracy: 0.01)
        XCTAssertEqual(CGFloat(0xF4) / 255.0, blue, accuracy: 0.01)
    }

    func testColorExtensions() {
        let color1 = UIColor(light: .white,
                             dark: .red)

        XCTAssertEqual(color1.light, UIColor.white)
        XCTAssertEqual(color1.lightHighContrast, UIColor.white)
        XCTAssertEqual(color1.lightElevated, UIColor.white)
        XCTAssertEqual(color1.lightElevatedHighContrast, UIColor.white)
        XCTAssertEqual(color1.dark, UIColor.red)
        XCTAssertEqual(color1.darkHighContrast, UIColor.red)
        XCTAssertEqual(color1.darkElevated, UIColor.red)
        XCTAssertEqual(color1.darkElevatedHighContrast, UIColor.red)

        let color2 = UIColor(light: .white,
                             lightHighContrast: .green,
                             lightElevated: .blue)

        XCTAssertEqual(color2.light, UIColor.white)
        XCTAssertEqual(color2.lightHighContrast, UIColor.green)
        XCTAssertEqual(color2.lightElevated, UIColor.blue)
        XCTAssertEqual(color2.lightElevatedHighContrast, UIColor.blue)
        XCTAssertEqual(color2.dark, UIColor.white)
        XCTAssertEqual(color2.darkHighContrast, UIColor.green)
        XCTAssertEqual(color2.darkElevated, UIColor.blue)
        XCTAssertEqual(color2.darkElevatedHighContrast, UIColor.blue)

        let color3 = UIColor(light: .white,
                             dark: .orange,
                             darkElevatedHighContrast: .magenta)

        XCTAssertEqual(color3.light, UIColor.white)
        XCTAssertEqual(color3.lightHighContrast, UIColor.white)
        XCTAssertEqual(color3.lightElevated, UIColor.white)
        XCTAssertEqual(color3.lightElevatedHighContrast, UIColor.white)
        XCTAssertEqual(color3.dark, UIColor.orange)
        XCTAssertEqual(color3.darkHighContrast, UIColor.orange)
        XCTAssertEqual(color3.darkElevated, UIColor.orange)
        XCTAssertEqual(color3.darkElevatedHighContrast, UIColor.magenta)
    }
}
