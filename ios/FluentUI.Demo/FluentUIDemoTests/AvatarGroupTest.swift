//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class AvatarGroupTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["AvatarGroup"].exists
        let avatarGroupCell = app.staticTexts["AvatarGroup"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            avatarGroupCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            avatarGroupCell.tap()
        }
    }

    func test() {}
}
