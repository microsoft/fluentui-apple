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

        let RGBAValues = "[0.0, 0.47058823529411764, 0.8313725490196079, 1.0]"
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*with rgba values.*\(RGBAValues).*")).element.exists)
    }

    // tests start/stop functionality as well as hiding (activity indicator should disappear when stopped)
    func testStartStopHide() throws {
        let startStopButton = app.buttons["Start / Stop activity"]

        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")).exists)
        startStopButton.tap()
        XCTAssert(!app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")).exists)

        app.cells.containing(.staticText, identifier: "Hides when stopped").firstMatch.tap()
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is progress halted")).exists)

        startStopButton.tap()
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")).exists)
    }

    func testDarkMode() throws {
        app.launchArguments.append("UITestingDarkModeEnabled")
        app.launch()

        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of default color.*")).element.exists)

        let RGBAValues = "[0.0, 0.5254901960784314, 0.9411764705882353, 1.0]"
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*with rgba values.*\(RGBAValues).*")).element.exists)
    }
}
