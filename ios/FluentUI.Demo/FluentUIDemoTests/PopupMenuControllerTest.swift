//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class PopupMenuControllerTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["PopupMenuController"].exists
        let popupMenuControllerCell = app.staticTexts["PopupMenuController"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            popupMenuControllerCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            popupMenuControllerCell.tap()
        }
    }

    func test() {}
}
