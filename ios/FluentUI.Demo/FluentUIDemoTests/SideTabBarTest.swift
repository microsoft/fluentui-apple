//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class SideTabBarTest: BaseTest {
    override var controlName: String { "SideTabBar" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    // launch test that ensures the demo app does not crash
    func testLaunch() throws {
        XCTAssertTrue(app.exists)
    }
}
