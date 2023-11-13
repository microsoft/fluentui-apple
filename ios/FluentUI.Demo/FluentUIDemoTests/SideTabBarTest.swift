//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class SideTabBarTest: BaseTest {
    override var controlName: String { "SideTabBar" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(!app.navigationBars.element.exists)
    }
}
