//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
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
