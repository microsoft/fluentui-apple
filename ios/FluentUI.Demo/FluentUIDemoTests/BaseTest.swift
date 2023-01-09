//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class BaseTest: XCTestCase {
    let app = XCUIApplication()
    // must be overridden
    var controlName: String { "Base" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()
        app.staticTexts[controlName].tap()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let icon = springboard.icons["FluentUI DEV"]
        if icon.exists {
            icon.press(forDuration: 1)

            let buttonRemoveApp = springboard.buttons["Remove App"]
            if buttonRemoveApp.waitForExistence(timeout: 5) {
                buttonRemoveApp.tap()
            }

            let buttonDeleteApp = springboard.alerts.buttons["Delete App"]
            if buttonDeleteApp.waitForExistence(timeout: 5) {
                buttonDeleteApp.tap()
            }

            let buttonDelete = springboard.alerts.buttons["Delete"]
            if buttonDelete.waitForExistence(timeout: 5) {
                buttonDelete.tap()
            }
        }
    }
}
