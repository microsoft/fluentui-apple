//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ActivityIndicatorTest: BaseTest {
    override var controlName: String { "ActivityIndicator" }

    let inProgress: NSPredicate = NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")
    let progressHalted: NSPredicate = NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is progress halted")

    func activityIndicatorExists(status: NSPredicate) -> Bool {
        return app.images.element(matching: status).exists
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    // tests start/stop functionality as well as hiding (activity indicator should disappear when stopped)
    func testStartStopHide() throws {
        let startStopButton: XCUIElement = app.buttons["Start / Stop activity"]
        let hidesWhenStoppedButton: XCUIElement = app.cells.containing(.staticText, identifier: "Hides when stopped").firstMatch

        XCTAssert(activityIndicatorExists(status: inProgress))
        startStopButton.tap()
        XCTAssert(!activityIndicatorExists(status: inProgress))

        hidesWhenStoppedButton.tap()
        XCTAssert(activityIndicatorExists(status: progressHalted))

        startStopButton.tap()
        XCTAssert(activityIndicatorExists(status: inProgress))
    }

    func testSizes() throws {
        // ensures all 5 activity indicators sizes are shown
        for i in 0...4 {
            XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size \(i).*")).element.exists)
        }
    }
}
