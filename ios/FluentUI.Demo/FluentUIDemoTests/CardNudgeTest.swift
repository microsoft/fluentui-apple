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
        XCTAssert(app.otherElements["Card Nudge with title \"Standard\", accent text \"Accent\", an icon, an accent icon, an action button titled \"Action\", and a dismiss button in style 0"].exists)
        app.cells.containing(.staticText, identifier: "Main Icon").firstMatch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge.*an icon.*")).element.exists)
        app.cells.containing(.staticText, identifier: "Subtitle").firstMatch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge.*subtitle.*")).element.exists)
        app.cells.containing(.staticText, identifier: "Accent Icon").firstMatch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge.*accent icon.*")).element.exists)
        app.cells.containing(.staticText, identifier: "Accent").firstMatch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge.*accent text.*")).element.exists)
        app.cells.containing(.staticText, identifier: "Dismiss Button").firstMatch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge.*dismiss button.*")).element.exists)
        app.cells.containing(.staticText, identifier: "Action Button").firstMatch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Card Nudge.*action button.*")).element.exists)
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
