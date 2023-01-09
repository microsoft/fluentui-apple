//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class BaseTest: XCTestCase {
    let app = XCUIApplication()
    let fluentUIDev: String = "FluentUI DEV"
    // must be overridden
    var controlName: String { "Base" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage: Bool = app.staticTexts[fluentUIDev].exists
        let controlPage: XCUIElement = app.staticTexts[controlName]
        let onDifferentControlPage: Bool = !onHomePage && !controlPage.exists
        let backButton: XCUIElement = app.buttons[fluentUIDev].exists ? app.buttons[fluentUIDev] : app.buttons["Dismiss"]

        if onHomePage {
            XCTAssertTrue(!onDifferentControlPage)
            controlPage.tap()
        } else if onDifferentControlPage {
            XCTAssertTrue(!onHomePage && !controlPage.exists)
            backButton.tap()
            controlPage.tap()
        }
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.icons[fluentUIDev].press(forDuration: 1)
        springboard.buttons["Remove App"].tap()
        springboard.alerts.buttons["Delete App"].tap()
        springboard.alerts.buttons["Delete"].tap()
    }
}
