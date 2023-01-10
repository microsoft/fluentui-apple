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
        // loops through first 5 activity indicators on the screen
        for i in 0...4 {
            // each activity indicator should decrease in size, starting with xLarge at size 4
            XCTAssertEqual(app.images.element(boundBy: i).identifier, "Activity Indicator that is in progress and size \(4 - i)")
        }
    }

    func testColor() throws {
        // loops through first 5 activity indicators on the screen
        for _ in 0...4 {
            XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress of default color")).exists)
        }

        let RGBAValues = "[0.0, 0.47058823529411764, 0.8313725490196079, 1.0]"
        // loops through last 5 activity indicators on the screen
        for _ in 5...9 {
            XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress with rgba values \(RGBAValues)")).exists)
        }
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
        app.buttons["ic fluent settings 24 regular"].tap()
        app.buttons["Dark"].tap()
        app.otherElements["dismiss popup"].tap()

        for _ in 0...4 {
            XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress of default color")).exists)
        }

        let RGBAValues = "[0.0, 0.47058823529411764, 0.8313725490196079, 1.0]"
        for _ in 5...9 {
            XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress with rgba values \(RGBAValues)")).exists)
        }
    }
}
