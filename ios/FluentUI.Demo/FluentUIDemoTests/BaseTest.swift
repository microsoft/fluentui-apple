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

        let onHomePage: Bool = app.staticTexts["FluentUI DEV"].exists
        if !onHomePage {
            if !app.navigationBars.element.exists {
                app.buttons["Dismiss"].tap()
            } else {
                app.buttons.firstMatch.tap()
            }
        }
        app.staticTexts[controlName].tap()
    }
}
