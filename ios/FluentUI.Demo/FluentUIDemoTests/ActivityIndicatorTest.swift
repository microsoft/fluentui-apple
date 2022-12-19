//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ActivityIndicatorTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        if app.staticTexts["FluentUI DEV"].exists {
            app.staticTexts["ActivityIndicator"].tap()
        } else if !app.staticTexts["ActivityIndicator"].exists {
            app.buttons["FluentUI DEV"].tap()
            app.staticTexts["ActivityIndicator"].tap()
        }
    }

    func testSizes() throws {
        XCTAssertEqual(app.images.element(boundBy: 0).identifier, "Activity Indicator that is In progress of size 4")
        XCTAssertEqual(app.images.element(boundBy: 1).identifier, "Activity Indicator that is In progress of size 3")
        XCTAssertEqual(app.images.element(boundBy: 2).identifier, "Activity Indicator that is In progress of size 2")
        XCTAssertEqual(app.images.element(boundBy: 3).identifier, "Activity Indicator that is In progress of size 1")
        XCTAssertEqual(app.images.element(boundBy: 4).identifier, "Activity Indicator that is In progress of size 0")
    }

    func testColor() throws {
        XCTAssertEqual(app.images.element(boundBy: 5).identifier, "Activity Indicator that is In progress of size 4 and color cyan blue")
        XCTAssertEqual(app.images.element(boundBy: 6).identifier, "Activity Indicator that is In progress of size 3 and color cyan blue")
        XCTAssertEqual(app.images.element(boundBy: 7).identifier, "Activity Indicator that is In progress of size 2 and color cyan blue")
        XCTAssertEqual(app.images.element(boundBy: 8).identifier, "Activity Indicator that is In progress of size 1 and color cyan blue")
        XCTAssertEqual(app.images.element(boundBy: 9).identifier, "Activity Indicator that is In progress of size 0 and color cyan blue")
    }

    func testStartStopHide() throws {
        XCTAssert(app.images["In progress"].exists)
        app.buttons["Start / Stop activity"].tap()
        XCTAssert(!app.images["In progress"].exists)

        app.cells.containing(.staticText, identifier: "Hides when stopped").firstMatch.tap()
        XCTAssert(app.images["Progress halted"].exists)

        app.buttons["Start / Stop activity"].tap()
        XCTAssert(app.images["In progress"].exists)
    }
}
