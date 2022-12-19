//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class DrawerControllerTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["DrawerController"].exists
        let drawerControllerCell = app.staticTexts["DrawerController"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            drawerControllerCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            drawerControllerCell.tap()
        }
    }

    func test() {}
}
