//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class TooltipTest: BaseTest {
    override var controlName: String { "Tooltip" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    func testMessage() throws {
        app.buttons["Show single-line tooltip below"].tap()
        XCTAssert(app.otherElements.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Tooltip with message \"This is pointing up.\"")).exists)
    }

    func testTitle() throws {
        app.buttons["Show single-line tooltip below"].tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Tooltip with.*title.*")).element.exists)
        app.buttons["Show tooltip with title above"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Tooltip with .*title \"This is a tooltip title\".*")).element.exists)
    }

    func testDirections() throws {
        app.buttons["Show single-line tooltip below"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Tooltip.*that is pointing up.*")).element.exists)
        app.buttons["Show tooltip with title above"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Tooltip.*that is pointing down.*")).element.exists)
        app.buttons["Show tooltip (with arrow left)"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Tooltip.*that is pointing left.*")).element.exists)
        // taps different part of screen since previous tooltip obscures next button
        app.otherElements.firstMatch.tap()
        app.buttons["Show tooltip (with arrow right)"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Tooltip.*that is pointing right.*")).element.exists)
    }
}
