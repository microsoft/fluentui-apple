//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class HUDTestSwiftUI: BaseTest {
    override var controlName: String { "HUD" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.staticTexts["SwiftUI Demo"].tap()
    }

    // launch test that ensures the demo app does not crash
    func testLaunch() throws {
        XCTAssertTrue(app.exists)
    }
}
