//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ActivityIndicatorTest: BaseTest {
    override var controlName: String { "ActivityIndicator" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    func testSizes() throws {
        // ensures all 5 activity indicators sizes are displayed
        for i in 0...4 {
            XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size \(i).*")).element.exists)
        }
    }

    func testColor() throws {
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of default color.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of color #0078d4.*")).element.exists)
    }

    // tests start/stop functionality as well as hiding (activity indicator should disappear when stopped)
    func testStartStopHide() throws {
        let startStopButton: XCUIElement = app.buttons["Start / Stop activity"]
        let inProgress: NSPredicate = NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")

        XCTAssert(app.images.element(matching: inProgress).exists)
        startStopButton.tap()
        XCTAssert(!app.images.element(matching: inProgress).exists)

        app.cells.containing(.staticText, identifier: "Hides when stopped").firstMatch.tap()
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is progress halted")).exists)

        startStopButton.tap()
        XCTAssert(app.images.element(matching: inProgress).exists)
    }

    func testDarkMode() throws {
        app.launchArguments.append("UITestingDarkModeEnabled")
        app.launch()

        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of default color.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of color #0086f0.*")).element.exists)
    }
}
