//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class DateTimePickerTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["DateTimePicker"].exists
        let dateTimePickerCell = app.staticTexts["DateTimePicker"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            dateTimePickerCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            dateTimePickerCell.tap()
        }
    }
}
