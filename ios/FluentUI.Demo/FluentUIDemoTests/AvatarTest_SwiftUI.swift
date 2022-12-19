//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class AvatarTestSwiftUI: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["Avatar"].exists
        let avatarCell = app.staticTexts["Avatar"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]
        let swiftUIDemoButton = app.staticTexts["SwiftUI Demo"]

        if onHomePage {
            avatarCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            avatarCell.tap()
        }
        swiftUIDemoButton.tap()
    }
}
