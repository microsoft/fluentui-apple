//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ProgressBarTestSwiftUI: ProgressBarTest {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    override func testLaunch() throws {
        XCTAssert(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    override func testStartStopHide() throws {
        let animatingSwitch: XCUIElement = app.switches["Animating"].switches.firstMatch
        let hidesWhenStoppedSwitch: XCUIElement = app.switches["Hides when stopped"].switches.firstMatch

        hidesWhenStoppedSwitch.tap()
        XCTAssert(progressBarExists(status: inProgress))
        XCTAssert(!progressBarExists(status: progressHalted))

        animatingSwitch.tap()
        XCTAssert(!progressBarExists(status: inProgress))
        XCTAssert(progressBarExists(status: progressHalted))

        hidesWhenStoppedSwitch.tap()
        XCTAssert(!progressBarExists(status: inProgress))
        XCTAssert(!progressBarExists(status: progressHalted))

        animatingSwitch.tap()
        XCTAssert(progressBarExists(status: inProgress))
        XCTAssert(!progressBarExists(status: progressHalted))
     }

    func testDeterminateMode() throws {
        let determinateSwitch: XCUIElement = app.switches["Determinate"].switches.firstMatch

        XCTAssert(progressBarExists(status: inProgress))
        XCTAssert(!progressBarExists(status: determinateProgress))

        determinateSwitch.tap()
        XCTAssert(!progressBarExists(status: inProgress))
        XCTAssert(progressBarExists(status: fortyPercentProgress))

        determinateSwitch.tap()
        XCTAssert(progressBarExists(status: inProgress))
        XCTAssert(!progressBarExists(status: determinateProgress))
    }

    func testDeterminateAutoAdvance() throws {
        let determinateSwitch: XCUIElement = app.switches["Determinate"].switches.firstMatch
        determinateSwitch.tap()

        let progressBar: XCUIElement = app.otherElements.element(matching: determinateProgress)
        XCTAssert(progressBarExists(status: fortyPercentProgress))

        let initialIdentifier: String = progressBar.identifier
        let autoAdvanceSwitch: XCUIElement = app.switches["Auto-advance progress"].switches.firstMatch
        autoAdvanceSwitch.tap()

        let progressChanged = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "identifier != %@", initialIdentifier),
            object: progressBar
        )
        XCTAssertEqual(XCTWaiter.wait(for: [progressChanged], timeout: 2), .completed)
    }
}
