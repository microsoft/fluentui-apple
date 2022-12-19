//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class TableViewCellTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["TableViewCell"].exists
        let tableViewCellCell = app.staticTexts["TableViewCell"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            tableViewCellCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            tableViewCellCell.tap()
        }
    }

    func test() {}
}
