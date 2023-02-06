//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class HUDTest: BaseTest {
    override var controlName: String { "HUD" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }
}
