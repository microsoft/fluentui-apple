//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import OfficeUIFabric

class MSButtonTests: XCTestCase {
    func testSimpleButton() {
        let button = MSButton()
        XCTAssert(button.layer.borderWidth == 1)
        XCTAssert(button.layer.cornerRadius == 8)
    }
}
