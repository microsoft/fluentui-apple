//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class PersonaListViewTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        let onHomePage = app.staticTexts["FluentUI DEV"].exists
        let onDifferentControlPage = !onHomePage && !app.staticTexts["PersonaListView"].exists
        let personaListViewCell = app.staticTexts["PersonaListView"]
        let backButton = app.buttons["FluentUI DEV"].exists ? app.buttons["FluentUI DEV"] : app.buttons["Dismiss"]

        if onHomePage {
            personaListViewCell.tap()
        } else if onDifferentControlPage {
            backButton.tap()
            personaListViewCell.tap()
        }
    }

    func test() {}
}
