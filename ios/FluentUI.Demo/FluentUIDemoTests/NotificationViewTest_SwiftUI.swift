//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class NotificationViewTestSwiftUI: BaseTest {
    override var controlName: String { "NotificationView" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.buttons["Show"].firstMatch.tap()
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Notification View")).exists)
    }
}
