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
        let controlPage: XCUIElement = app.staticTexts[controlName]
        if onHomePage {
            controlPage.tap()
            return
        }

        let onDifferentControlPage: Bool = {
            // handles edge case of SideTabBar first
            if !app.navigationBars.element.exists {
                return controlName != "SideTabBar"
            }
            return !app.navigationBars.element.staticTexts[controlName].exists
        }()
        let backButton: XCUIElement = app.navigationBars.element.exists ? app.buttons.firstMatch : app.buttons["Dismiss"]

        if onDifferentControlPage {
            backButton.tap()
            controlPage.tap()
        }
    }
}
