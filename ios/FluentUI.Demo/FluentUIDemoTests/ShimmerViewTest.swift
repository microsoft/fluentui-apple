//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ShimmerViewTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["ShimmerView"].exists
        let shimmerViewCell = app.staticTexts["ShimmerView"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            shimmerViewCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            shimmerViewCell.tap()
        }
    }

    func test() {}
}
