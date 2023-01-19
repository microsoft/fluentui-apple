//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class IndeterminateProgressBarTestSwiftUI: IndeterminateProgressBarTest {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    override func testLaunch() throws {
        XCTAssertTrue(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    override func testStartStopHide() throws {
         let animatingSwitch: XCUIElement = app.switches["Animating"]
         let hidesWhenStoppedSwitch: XCUIElement = app.switches["Hides when stopped"]

         hidesWhenStoppedSwitch.tap()
         XCTAssert(super.indeterminateProgressBarExists(status: super.inProgress))

         animatingSwitch.tap()
         XCTAssert(super.indeterminateProgressBarExists(status: super.progressHalted))

         hidesWhenStoppedSwitch.tap()
         XCTAssert(!super.indeterminateProgressBarExists(status: super.inProgress))

         animatingSwitch.tap()
         XCTAssert(super.indeterminateProgressBarExists(status: super.inProgress))
     }
}
