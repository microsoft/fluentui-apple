//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class IndeterminateProgressBarTest: BaseTest {
    override var controlName: String { "IndeterminateProgressBar" }

    let inProgress: NSPredicate = NSPredicate(format: "identifier CONTAINS %@", "Indeterminate Progress Bar that is in progress")
    let progressHalted: NSPredicate = NSPredicate(format: "identifier CONTAINS %@", "Indeterminate Progress Bar that is progress halted")

    func indeterminateProgressBarExists(status: NSPredicate) -> Bool {
         return app.otherElements.element(matching: status).exists
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    // tests start/stop functionality as well as hiding (indeterminate progress bar should disappear when stopped)
    func testStartStopHide() throws {
        let startStopButton: XCUIElement = app.buttons["Start / Stop activity"]
        let hidesWhenStoppedButton: XCUIElement = app.cells.containing(.staticText, identifier: "Hides when stopped").firstMatch

        XCTAssert(indeterminateProgressBarExists(status: inProgress))
        XCTAssert(!indeterminateProgressBarExists(status: progressHalted))
        startStopButton.tap()
        XCTAssert(!indeterminateProgressBarExists(status: inProgress))
        XCTAssert(!indeterminateProgressBarExists(status: progressHalted))

        hidesWhenStoppedButton.tap()
        XCTAssert(!indeterminateProgressBarExists(status: inProgress))
        XCTAssert(indeterminateProgressBarExists(status: progressHalted))

        startStopButton.tap()
        XCTAssert(indeterminateProgressBarExists(status: inProgress))
        XCTAssert(!indeterminateProgressBarExists(status: progressHalted))
    }
}
