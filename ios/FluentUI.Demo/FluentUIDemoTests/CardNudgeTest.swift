//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class CardNudgeTest: BaseTest {
    override var controlName: String { "CardNudge" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    func testElements() throws {
        let mainIconSwitch: XCUIElement = app.tables.element(boundBy: 0).cells.element(boundBy: 2)
        let subtitleSwitch: XCUIElement = app.tables.element(boundBy: 0).cells.element(boundBy: 3)

        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge with title \"Standard\", subtitle \"Subtitle\", accent text \"Accent\", an icon, an accent icon, an action button titled \"Action\", and a dismiss button.*")).element.exists)
        mainIconSwitch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge.*an icon.*")).element.exists)
        subtitleSwitch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge.*subtitle.*")).element.exists)
    }

    func testActions() throws {
        app.buttons["Action"].firstMatch.tap()
        XCTAssert(app.alerts["Standard action performed"].exists)
        app.buttons["OK"].tap()
        app.cells.containing(.staticText, identifier: "Action Button").firstMatch.tap()
        XCTAssert(!app.buttons["Action"].exists)

        app.buttons["Dismiss"].firstMatch.tap()
        XCTAssert(app.alerts["Standard was dismissed"].exists)
        app.buttons["OK"].tap()
        app.cells.containing(.staticText, identifier: "Dismiss Button").firstMatch.tap()
        XCTAssert(!app.buttons["Dismiss"].exists)
    }
}
