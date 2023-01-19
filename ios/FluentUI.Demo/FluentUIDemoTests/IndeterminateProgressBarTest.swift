//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class IndeterminateProgressBarTest: BaseTest {
    override var controlName: String { "IndeterminateProgressBar" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    // tests start/stop functionality as well as hiding (indeterminate progress bar should disappear when stopped)
    func testStartStopHide() throws {
        let startStopButton: XCUIElement = app.buttons["Start / Stop activity"]
        let inProgress: NSPredicate = NSPredicate(format: "identifier CONTAINS %@", "Indeterminate Progress Bar that is in progress")

        XCTAssert(app.otherElements.element(matching: inProgress).exists)
        startStopButton.tap()
        XCTAssert(!app.otherElements.element(matching: inProgress).exists)

        app.cells.containing(.staticText, identifier: "Hides when stopped").firstMatch.tap()
        XCTAssert(app.otherElements.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Indeterminate Progress Bar that is progress halted")).exists)

        startStopButton.tap()
        XCTAssert(app.otherElements.element(matching: inProgress).exists)
    }
}
