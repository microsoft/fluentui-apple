//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class IndeterminateProgressBarTestSwiftUI: BaseTest {
    override var controlName: String { "IndeterminateProgressBar" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    // tests indeterminate progress bar's start/stop functionality
     func testAnimating() throws {
         app.switches["Hides when stopped"].tap()
         XCTAssert(app.otherElements.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Indeterminate Progress Bar that is in progress")).exists)

         app.switches["Animating"].tap()
         XCTAssert(app.otherElements.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Indeterminate Progress Bar that is progress halted")).exists)
     }

     // ensures that indeterminate progress bar disappears when stopped
     func testHidingWhenStoppedOn() throws {
         let inProgress: NSPredicate = NSPredicate(format: "identifier CONTAINS %@", "Indeterminate Progress Bar that is in progress")
         XCTAssert(app.otherElements.element(matching: inProgress).exists)
         app.switches["Animating"].tap()
         XCTAssert(!app.otherElements.element(matching: inProgress).exists)
     }
}
