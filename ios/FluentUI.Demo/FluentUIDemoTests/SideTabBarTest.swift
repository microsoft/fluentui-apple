//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class SideTabBarTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["SideTabBar"].exists
        let sideTabBarCell = app.staticTexts["SideTabBar"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            sideTabBarCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            sideTabBarCell.tap()
        }
    }

    func test() {}
}
