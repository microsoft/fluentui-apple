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
