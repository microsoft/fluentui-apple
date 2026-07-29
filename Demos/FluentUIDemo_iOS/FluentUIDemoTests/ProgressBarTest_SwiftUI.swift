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
}
