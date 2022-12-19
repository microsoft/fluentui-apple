//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class TableViewCellFileAccessoryViewTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["TableViewCellFileAccessoryView"].exists
        let tableViewCellFileAccessoryViewCell = app.staticTexts["TableViewCellFileAccessoryView"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            tableViewCellFileAccessoryViewCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            tableViewCellFileAccessoryViewCell.tap()
        }
    }
}
