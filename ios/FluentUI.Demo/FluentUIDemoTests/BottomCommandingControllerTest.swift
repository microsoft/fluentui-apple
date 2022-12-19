//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class BottomCommandingControllerTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["BottomCommandingController"].exists
        let bottomCommandingControllerCell = app.staticTexts["BottomCommandingController"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            bottomCommandingControllerCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            bottomCommandingControllerCell.tap()
        }
    }
}
