//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

extension XCTestCase {
    // helper method to navigate to the specified control page.
    func navigateToControl(app: XCUIApplication, controlName: String) {
        let fluentUIDev: String = "FluentUI DEV"
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
}
