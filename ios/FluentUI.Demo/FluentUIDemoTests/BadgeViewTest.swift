//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class BadgeViewTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["BadgeView"].exists
        let badgeViewCell = app.staticTexts["BadgeView"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            badgeViewCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            badgeViewCell.tap()
        }
    }

    func test() {}
}
