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
        springboard.icons["FluentUI DEV"].press(forDuration: 1)
        springboard.buttons["Remove App"].tap()
        springboard.alerts.buttons["Delete App"].tap()
        springboard.alerts.buttons["Delete"].tap()
    }
}
