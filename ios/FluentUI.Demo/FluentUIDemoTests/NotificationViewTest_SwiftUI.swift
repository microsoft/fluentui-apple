//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class NotificationViewTestSwiftUI: XCTestCase {
    let app = XCUIApplication()
    var controlName: String = "NotificationView"

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()
        navigateToControl(app: app, controlName: controlName)
        app.buttons["Show"].firstMatch.tap()
    }

    // launch test that ensures the demo app does not crash
    func testLaunch() throws {
        XCTAssertTrue(app.exists)
    }
}
