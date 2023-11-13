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
        XCTAssert(app.navigationBars[controlName].exists)
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

    // ensures tooltip disappears when you tap on the tooltip and elsewhere
    func testNormalDismissal() throws {
        let showTooltipButton: XCUIElement = app.buttons["Show single-line tooltip below"]
        let tooltip: XCUIElement = app.otherElements.element(matching: NSPredicate(format: "label CONTAINS %@", "This is pointing up."))

        showTooltipButton.tap()
        XCTAssert(tooltip.exists)
        tooltip.tap()
        XCTAssert(!tooltip.exists)

        showTooltipButton.tap()
        XCTAssert(tooltip.exists)
        app.otherElements.firstMatch.tap()
        XCTAssert(!tooltip.exists)
    }

    // ensures tooltip only disappears when you tap on the tooltip
    func testTooltipTapDismissal() throws {
        let showTooltipButton: XCUIElement = app.buttons["Show with tap on tooltip dismissal"]
        let tooltip: XCUIElement = app.otherElements.element(matching: NSPredicate(format: "label CONTAINS %@", "Tap on this tooltip to dismiss."))

        showTooltipButton.tap()
        XCTAssert(tooltip.exists)
        tooltip.tap()
        XCTAssert(!tooltip.exists)

        showTooltipButton.tap()
        XCTAssert(tooltip.exists)
        app.otherElements.firstMatch.tap()
        XCTAssert(tooltip.exists)
    }

    // ensures tooltip only disappears when you tap on the tooltip or anchor
    func testTooltipAnchorTapDismissal() throws {
        let showTooltipButton: XCUIElement = app.buttons["Show with tap on tooltip or anchor dismissal"]
        let tooltip: XCUIElement = app.otherElements.element(matching: NSPredicate(format: "label CONTAINS %@", "Tap on this tooltip or this title button to dismiss."))

        showTooltipButton.tap()
        XCTAssert(tooltip.exists)
        tooltip.tap()
        XCTAssert(!tooltip.exists)

        showTooltipButton.tap()
        XCTAssert(tooltip.exists)
        app.staticTexts["Tooltip"].firstMatch.tap()
        // dismisses alert
        app.buttons["OK"].tap()
        XCTAssert(!tooltip.exists)

        showTooltipButton.tap()
        XCTAssert(tooltip.exists)
        app.otherElements.firstMatch.tap()
        XCTAssert(tooltip.exists)
    }
}
