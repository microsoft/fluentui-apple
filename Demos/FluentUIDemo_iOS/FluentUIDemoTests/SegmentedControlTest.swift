//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class SegmentedControlTest: BaseTest {
    override var controlName: String { "SegmentedControl" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    func testSelection() throws {
        let firstPillButton: XCUIElement = app.buttons["First"].firstMatch
        let secondUnreadPillButton: XCUIElement = app.buttons["Second, unread"].firstMatch
        let thirdUnreadPillButton: XCUIElement = app.buttons["Third, unread"].firstMatch
        let secondPillButton: XCUIElement = app.buttons["Second"].firstMatch
        let thirdPillButton: XCUIElement = app.buttons["Third"].firstMatch

        XCTAssert(app.otherElements["Segmented Control with 3 enabled buttons"].firstMatch.exists)
        XCTAssert(app.staticTexts["\"First\" segment is selected"].exists)
        XCTAssert(firstPillButton.isSelected)
        XCTAssert(!secondUnreadPillButton.isSelected)
        XCTAssert(!thirdUnreadPillButton.isSelected)

        secondUnreadPillButton.tap()
        XCTAssert(app.staticTexts["\"Second\" segment is selected"].exists)
        XCTAssert(!firstPillButton.isSelected)
        XCTAssert(secondPillButton.isSelected)
        XCTAssert(!thirdUnreadPillButton.isSelected)

        thirdUnreadPillButton.tap()
        XCTAssert(app.staticTexts["\"Third\" segment is selected"].exists)
        XCTAssert(!firstPillButton.isSelected)
        XCTAssert(!secondPillButton.isSelected)
        XCTAssert(thirdPillButton.isSelected)
    }

    func testScrolling() throws {
        let lastPillButton: XCUIElement = app.buttons["Tenth"].firstMatch
        lastPillButton.tap()
        XCTAssert(app.staticTexts["\"Tenth\" segment is selected"].exists)
        XCTAssert(lastPillButton.isSelected)
    }

    func testDisabledPill() throws {
        let disabledSegmentedControl: XCUIElement = app.otherElements["Segmented Control with 2 disabled buttons"].firstMatch

        XCTAssert(disabledSegmentedControl.exists)
        XCTAssert(disabledSegmentedControl.buttons["First"].isSelected)
        disabledSegmentedControl.buttons["Second, unread"].tap()
        XCTAssert(disabledSegmentedControl.buttons["First"].isSelected)
        XCTAssert(!disabledSegmentedControl.buttons["Second, unread"].isSelected)
    }
}
