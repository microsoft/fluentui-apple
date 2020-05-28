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

}
