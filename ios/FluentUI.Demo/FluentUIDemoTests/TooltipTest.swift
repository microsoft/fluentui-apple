//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class TooltipTest: BaseTest {
    override var controlName: String { "Tooltip" }

    func tooltipExists(predicate: NSPredicate) -> Bool {
        return app.otherElements.containing(predicate).element.exists
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    func testMessage() throws {
        let showTooltipButton: XCUIElement = app.buttons["Show single-line tooltip below"]
        let message: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Tooltip with message \"This is pointing up.\".*")

        showTooltipButton.tap()
        XCTAssert(tooltipExists(predicate: message))
    }

    func testTitle() throws {
        let showTooltipBelowButton: XCUIElement = app.buttons["Show single-line tooltip below"]
        let showTooltipAboveButton: XCUIElement = app.buttons["Show tooltip with title above"]
        let noTitle: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Tooltip with.*title.*")
        let title: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Tooltip with .*title \"This is a tooltip title\".*")

        showTooltipBelowButton.tap()
        XCTAssert(!tooltipExists(predicate: noTitle))
        showTooltipAboveButton.tap()
        XCTAssert(tooltipExists(predicate: title))
    }

    func testDirections() throws {
        let showTooltipBelowButton: XCUIElement = app.buttons["Show single-line tooltip below"]
        let showTooltipAboveButton: XCUIElement = app.buttons["Show tooltip with title above"]
        let showTooltipLeftButton: XCUIElement = app.buttons["Show tooltip (with arrow left)"]
        let showTooltipRightButton: XCUIElement = app.buttons["Show tooltip (with arrow right)"]

        let up: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Tooltip.*that is pointing up.*")
        let down: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Tooltip.*that is pointing down.*")
        let left: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Tooltip.*that is pointing left.*")
        let right: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Tooltip.*that is pointing right.*")

        showTooltipBelowButton.tap()
        XCTAssert(tooltipExists(predicate: up))
        showTooltipAboveButton.tap()
        XCTAssert(tooltipExists(predicate: down))
        showTooltipLeftButton.tap()
        XCTAssert(tooltipExists(predicate: left))
        // taps different part of screen since previous tooltip obscures next button
        app.otherElements.firstMatch.tap()
        showTooltipRightButton.tap()
        XCTAssert(tooltipExists(predicate: right))
    }
}
