//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class TypographyTokensTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["TypographyTokens"].exists
        let typographyTokensCell = app.staticTexts["TypographyTokens"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            typographyTokensCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            typographyTokensCell.tap()
        }
    }

    func test() {}
}
