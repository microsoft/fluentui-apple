//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
import SwiftUI
@testable import FluentUI

class FontTests: XCTestCase {

    func testBasicFont() throws {
        // Basic system font
        let size = 24.0

        let fontInfo = FontInfo(size: size)
        let font = UIFont.fluent(fontInfo)
        let otherFont = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
        XCTAssertEqual(font.fontDescriptor, otherFont.fontDescriptor)
    }

    func testAdvancedFont() throws {
        // More advanced font info
        let name = "Baskerville"
        let size = 16.0
        let weight = Font.Weight.semibold

        let fontInfo = FontInfo(name: name, size: size, weight: weight)
        let font = UIFont.fluent(fontInfo)
        let otherFontDescriptor = UIFontDescriptor(name: name.appending("-Semibold"), size: size)
        let otherFont = UIFont(descriptor: otherFontDescriptor, size: size)
        XCTAssertEqual(font.fontDescriptor, otherFont.fontDescriptor)
    }

    func testScalingFont() throws {
        // Scaling
        let size = 24.0

        let fontInfo = FontInfo(size: size)
        let font = UIFont.fluent(fontInfo, shouldScale: true)
        let otherFont = UIFont.systemFont(ofSize: UIFontMetrics.default.scaledValue(for: fontInfo.size))
        XCTAssertEqual(font.fontDescriptor, otherFont.fontDescriptor)
    }
}
