//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class OtherCellsTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["Other cells"].exists
        let otherCellsCell = app.staticTexts["Other cells"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            otherCellsCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            otherCellsCell.tap()
        }
    }

    func test() {}
}
