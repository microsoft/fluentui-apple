//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
import SwiftUI
#if canImport(FluentUI_common)
@testable import FluentUI_common
#endif
@testable import FluentUI_ios

class ColorTests: XCTestCase {

    func testUIColorHexValue() {
        let hexValue = UInt32(0xC7E0F4)
        let color = UIColor(hexValue: hexValue)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        // Verify that UIColor's getters return the same values as the hex value
        XCTAssertTrue(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        XCTAssertEqual(1.0, alpha)
        XCTAssertEqual(CGFloat(0xC7) / 255.0, red, accuracy: 0.01)
        XCTAssertEqual(CGFloat(0xE0) / 255.0, green, accuracy: 0.01)
        XCTAssertEqual(CGFloat(0xF4) / 255.0, blue, accuracy: 0.01)
    }

    func testColorHexValue() {
        let hexValue = UInt32(0xC7E0F4)
        let color = Color(hexValue: hexValue)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        // Verify that UIColor's getters return the same values as the hex value
        let uiColor = UIColor(color)
        XCTAssertTrue(uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
        XCTAssertEqual(1.0, alpha)
        XCTAssertEqual(CGFloat(0xC7) / 255.0, red, accuracy: 0.01)
        XCTAssertEqual(CGFloat(0xE0) / 255.0, green, accuracy: 0.01)
        XCTAssertEqual(CGFloat(0xF4) / 255.0, blue, accuracy: 0.01)

        let components = color.resolve(in: EnvironmentValues())
        XCTAssertEqual(red, CGFloat(components.red), accuracy: 0.01)
        XCTAssertEqual(green, CGFloat(components.green), accuracy: 0.01)
        XCTAssertEqual(blue, CGFloat(components.blue), accuracy: 0.01)
        XCTAssertEqual(alpha, CGFloat(components.opacity), accuracy: 0.01)
    }

    func testDynamicColorValue() {
        let dynamicColor = DynamicColor(light: .white,
                                        dark: .black)
        let dynamicUIColor = UIColor(dynamicColor: dynamicColor)
        XCTAssertEqual(dynamicUIColor.light, UIColor(Color.white))
        XCTAssertEqual(dynamicUIColor.dark, UIColor(Color.black))
        XCTAssertEqual(dynamicUIColor.darkElevated, UIColor(Color.black))

        var lightColorEnvironment = EnvironmentValues()
        lightColorEnvironment.colorScheme = .light
        XCTAssertEqual(lightColorEnvironment.colorScheme, .light)
        let lightColor = dynamicColor.resolve(in: lightColorEnvironment)
        XCTAssertEqual(lightColor, Color.white.resolve(in: .init()))

        var darkColorEnvironment = EnvironmentValues()
        darkColorEnvironment.colorScheme = .dark
        XCTAssertEqual(darkColorEnvironment.colorScheme, .dark)
        let darkColor = dynamicColor.resolve(in: darkColorEnvironment)
        XCTAssertEqual(darkColor, Color.black.resolve(in: darkColorEnvironment))
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
