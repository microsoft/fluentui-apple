//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ListActionItemTest: BaseTest {
    override var controlName: String { "ListActionItem" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    func testSingleAction() throws {
        let textField: XCUIElement = app.textFields.matching(identifier: "primaryActionTitleTextField").firstMatch
        let newTitle: String = "New action"

        primaryButton.tap()
        XCTAssert(actionAlert.exists, "Should run action handler for ListActionItem when tapped")
        dismissAlertButton.tap()

        clearText(in: textField)
        textField.typeText(newTitle)
        XCTAssert(primaryButton.label == newTitle, "Title should update when passed in value changes")
    }

    func testTwoActions() throws {
        let primaryActionTitleTextField: XCUIElement = app.textFields.matching(identifier: "primaryActionTitleTextField").firstMatch
        let secondaryActionTitleTextField: XCUIElement = app.textFields.matching(identifier: "secondaryActionTitleTextField").firstMatch
        let newPrimaryActionTitle: String = "Dismiss"
        let newSecondaryActionTitle: String = "Error"

        primaryButton.tap()
        XCTAssert(actionAlert.exists, "Should run action handler for primary action ListActionItem when tapped")
        dismissAlertButton.tap()

        secondaryButton.tap()
        XCTAssert(actionAlert.exists, "Should run action handler for secondary action ListActionItem when tapped")
        dismissAlertButton.tap()

        clearText(in: primaryActionTitleTextField)
        primaryActionTitleTextField.typeText(newPrimaryActionTitle)
        XCTAssert(primaryButton.label == newPrimaryActionTitle, "Primary action title should update when passed in value changes")

        clearText(in: secondaryActionTitleTextField)
        secondaryActionTitleTextField.typeText(newSecondaryActionTitle)
        XCTAssert(secondaryButton.label == newSecondaryActionTitle, "Secondary action title should update when passed in value changes")
    }

    // MARK: Helper functions and variables

    func clearText(in textField: XCUIElement) {
        textField.tap()
        let currentText = textField.value as? String ?? ""
        textField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count))
    }

    var primaryButton: XCUIElement {
        app.buttons.matching(identifier: "ListActionItemPrimaryButton").firstMatch
    }

    var secondaryButton: XCUIElement {
        app.buttons.matching(identifier: "ListActionItemSecondaryButton").firstMatch
    }

    var actionAlert: XCUIElement {
        app.alerts.firstMatch
    }

    var dismissAlertButton: XCUIElement {
        app.buttons.matching(identifier: "DismissAlertButton").firstMatch
    }
}
