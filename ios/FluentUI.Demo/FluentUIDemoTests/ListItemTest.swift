//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ListItemTest: BaseTest {
    override var controlName: String { "ListItem" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Set starting values for all settings
    }

    func testSubtitle() throws {
        let showSubtitleSwitch: XCUIElement = app.switches["Show subtitle"].switches.firstMatch

        showSubtitleSwitch.tap()
        XCTAssert(app.staticTexts.matching(identifier: "subtitle").firstMatch.exists)
        showSubtitleSwitch.tap()
        XCTAssert(!app.staticTexts.matching(identifier: "subtitle").firstMatch.exists)
    }

    func testFooter() throws {
        let showSubtitleSwitch: XCUIElement = app.switches["Show subtitle"].switches.firstMatch
        let showFooterSwitch: XCUIElement = app.switches["Show footer"].switches.firstMatch
        // footer should not be shown if subtitle is not
        XCTAssert(!app.staticTexts.matching(identifier: "footer").firstMatch.exists)
        showSubtitleSwitch.tap()
        showFooterSwitch.tap()
        XCTAssert(app.staticTexts.matching(identifier: "footer").firstMatch.exists)
        showFooterSwitch.tap()
        XCTAssert(!app.staticTexts.matching(identifier: "footer").firstMatch.exists)
    }

    func testLeadingContent() throws {
        let showLeadingContentSwitch: XCUIElement = app.switches["Show leading content"].switches.firstMatch
        XCTAssert(app.images.matching(identifier: "leadingContent").firstMatch.exists)
        showLeadingContentSwitch.tap()
        XCTAssert(!app.images.matching(identifier: "leadingContent").firstMatch.exists)
    }

    func testTrailingContent() throws {
        let showTrailingContentSwitch: XCUIElement = app.switches["Show trailing content"].switches.firstMatch
        XCTAssert(app.staticTexts.matching(identifier: "trailingContent").firstMatch.exists)
        showTrailingContentSwitch.tap()
        XCTAssert(!app.staticTexts.matching(identifier: "trailingContent").firstMatch.exists)
    }
}
