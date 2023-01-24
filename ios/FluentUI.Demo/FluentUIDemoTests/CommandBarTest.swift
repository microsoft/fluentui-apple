//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class CommandBarTest: BaseTest {
    override var controlName: String { "CommandBar" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    func testLeadingTrailingButton() throws {
        XCTAssert(app.otherElements["Command Bar with 1 leading button and 0 trailing buttons"].exists)
        app.buttons["Refresh Trailing Button"].tap()
        XCTAssert(app.otherElements["Command Bar with 1 leading button and 1 trailing button"].exists)
        app.buttons["Remove Leading Button"].tap()
        XCTAssert(app.otherElements["Command Bar with 0 leading buttons and 1 trailing button"].exists)
        app.buttons["Remove Trailing Button"].tap()
        XCTAssert(app.otherElements["Command Bar with 0 leading buttons and 0 trailing buttons"].exists)
        app.buttons["Refresh Leading Button"].tap()
        XCTAssert(app.otherElements["Command Bar with 1 leading button and 0 trailing buttons"].exists)
    }

    func testChangeTextStyleButton() throws {
        let textStyleButton: XCUIElement = app.buttons.element(boundBy: 15)

        XCTAssert(app.buttons["Body"].exists)
        textStyleButton.tap()
        XCTAssert(app.buttons["Title"].exists)
        textStyleButton.tap()
        XCTAssert(app.buttons["Subhead"].exists)
        textStyleButton.tap()
        XCTAssert(app.buttons["Body"].exists)
    }

    func testSelectBoldButton() throws {
        let boldButton: XCUIElement = app.buttons.element(boundBy: 17)
        let notification: XCUIElement = app.alerts["Did select command textBold"]
        let okButton: XCUIElement = app.buttons["OK"]

        XCTAssert(!boldButton.isSelected)
        boldButton.tap()
        XCTAssert(notification.exists)
        okButton.tap()
        XCTAssert(boldButton.isSelected)
    }

    func testDisablePlusButton() throws {
        let addButton: XCUIElement = app.buttons["Add"].firstMatch
        let notification: XCUIElement = app.alerts["Did select command add"]
        let okButton: XCUIElement = app.buttons["OK"]
        let disablePlusSwitch: XCUIElement = app.switches.element(boundBy: 1)

        addButton.tap()
        XCTAssert(notification.exists)
        okButton.tap()

        disablePlusSwitch.tap()
        addButton.tap()
        XCTAssert(!notification.exists)
    }

    func testRemoveDeleteButton() throws {
        let numButtons: Int = app.buttons.count
        let removeDeleteButtonSwitch: XCUIElement = app.switches.element(boundBy: 2)

        removeDeleteButtonSwitch.tap()
        XCTAssert(app.buttons.count == numButtons - 1)
    }
}
