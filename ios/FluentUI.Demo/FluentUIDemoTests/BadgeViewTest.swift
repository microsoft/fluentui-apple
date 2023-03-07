//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class BadgeViewTest: BaseTest {
    override var controlName: String { "BadgeView" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    func testEnabledBadge() throws {
        let badge: XCUIElement = app.buttons.containing(NSPredicate(format: "identifier MATCHES %@", "Badge.*")).firstMatch
        badge.doubleTap()
        XCTAssert(app.alerts["A selected badge was tapped"].exists)
        app.buttons["OK"].tap()
    }

    func testDisabledBadge() throws {
        let badge: XCUIElement = app.buttons.containing(NSPredicate(format: "identifier MATCHES %@", "Badge.*")).element(boundBy: 12)
        badge.doubleTap()
        XCTAssert(!app.alerts["A selected badge was tapped"].exists)
    }
}
