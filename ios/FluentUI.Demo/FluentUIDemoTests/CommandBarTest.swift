//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class CommandBarTest: BaseTest {
    override var controlName: String { "CommandBar" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    // ensures that adding (refreshing)/removing leading/trailing button works as expected
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

    // ensures that tapping on text style button rotates through text styles
    func testChangeTextStyleButton() throws {
        let textStyleButtonNumber: Int = 15
        let textStyleButton: XCUIElement = app.buttons.element(boundBy: textStyleButtonNumber)

        XCTAssert(app.buttons["Body"].exists)
        textStyleButton.tap()
        XCTAssert(app.buttons["Title"].exists)
        textStyleButton.tap()
        XCTAssert(app.buttons["Subhead"].exists)
        textStyleButton.tap()
        XCTAssert(app.buttons["Body"].exists)
    }

    func testSelectBoldButton() throws {
        let boldButtonNumber: Int = 17
        let boldButton: XCUIElement = app.buttons.element(boundBy: boldButtonNumber)
        let alert: XCUIElement = app.alerts["Did select command textBold"]
        let okButton: XCUIElement = app.buttons["OK"]

        XCTAssert(!boldButton.isSelected)
        boldButton.tap()
        XCTAssert(alert.exists)
        okButton.tap()
        XCTAssert(boldButton.isSelected)
    }

    func testDisablePlusButton() throws {
        let addButton: XCUIElement = app.buttons["Add"].firstMatch
        let alert: XCUIElement = app.alerts["Did select command add"]
        let okButton: XCUIElement = app.buttons["OK"]
        let disableAddButtonSwitch: XCUIElement = app.switches.element(boundBy: 1)

        addButton.tap()
        XCTAssert(alert.exists)
        okButton.tap()

        disableAddButtonSwitch.tap()
        addButton.tap()
        XCTAssert(!alert.exists)
    }

    func testRemoveDeleteButton() throws {
        let numButtons: Int = app.buttons.count
        let removeDeleteButtonSwitch: XCUIElement = app.switches.element(boundBy: 3)

        removeDeleteButtonSwitch.tap()
        XCTAssert(app.buttons.count == numButtons - 1)
    }

    // ensures that command bar pops up/disappears as expected
    func testInputAccessoryView() throws {
        let numButtons: Int = app.buttons.count

        app.textFields.firstMatch.tap()
        XCTAssert(app.buttons.count > numButtons)
        XCTAssert(app.otherElements["Command Bar with 0 leading buttons and 1 trailing button"].exists)

        // taps dismiss command bar button
        app.buttons.element(boundBy: 31).tap()
        XCTAssert(app.buttons.count == numButtons)
        XCTAssert(!app.otherElements["Command Bar with 0 leading buttons and 1 trailing button"].exists)
    }
}
