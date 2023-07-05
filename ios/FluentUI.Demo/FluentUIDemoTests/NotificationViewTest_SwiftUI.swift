//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class NotificationViewTestSwiftUI: BaseTest {
    override var controlName: String { "NotificationView" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.buttons["Show"].firstMatch.tap()
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Notification View")).exists)
    }

    func testText() throws {
        let titleTextField: XCUIElement = app.textFields.element(boundBy: 0)
        let messageTextField: XCUIElement = app.textFields.element(boundBy: 1)
        let actionButtonTextField: XCUIElement = app.textFields.element(boundBy: 2)
        let attributedTextSwitch: XCUIElement = app.switches["Has Attributed Text: Strikethrough"].switches.firstMatch

        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*message \"Mail Archived\".*action button titled \"Undo\".*")).element.exists)

        titleTextField.tap()
        titleTextField.typeText("title\n")
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View with title \"title\", message \"Mail Archived\".*action button titled \"Undo\".*")).element.exists)

        attributedTextSwitch.tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View with attributed title \"title\", attributed message \"Mail Archived\".*action button titled \"Undo\".*")).element.exists)

        titleTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        titleTextField.typeText(String(XCUIKeyboardKey.delete.rawValue) + "\n")
        messageTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        messageTextField.typeText(String(XCUIKeyboardKey.delete.rawValue) + "\n")
        actionButtonTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        actionButtonTextField.typeText(String(XCUIKeyboardKey.delete.rawValue) + "\n")
        // if there is no action button title, there should be a dismiss button
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View with no title, no message.*dismiss button.*")).element.exists)
    }

    func testImages() {
        let actionButtonTextField: XCUIElement = app.textFields.element(boundBy: 2)
        let setImageSwitch: XCUIElement = app.switches["Set image"].switches.firstMatch
        let setTrailingImageSwitch: XCUIElement = app.switches["Set trailing image"].switches.firstMatch

        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*image.*")).element.exists)
        setImageSwitch.tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*image.*")).element.exists)

        setTrailingImageSwitch.tap()
        // as long as there is a action button title, there should be no trailing image
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*trailing image.*")).element.exists)
        actionButtonTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        actionButtonTextField.typeText(String(XCUIKeyboardKey.delete.rawValue) + "\n")
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*trailing image.*")).element.exists)
        setTrailingImageSwitch.tap()
        // if there is no action button title, there should be a dismiss button
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*dismiss button.*")).element.exists)
    }

    func testActions() throws {
        let notificationView: XCUIElement = app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*")).element(boundBy: 7)
        let actionButton: XCUIElement = app.buttons["Undo"].firstMatch

        let hasActionButtonActionSwitch: XCUIElement = app.switches["Has Action Button Action"].switches.firstMatch
        let hasMessageActionSwitch: XCUIElement = app.switches["Has Message Action"].switches.firstMatch

        let alert: XCUIElement = app.alerts["Button tapped"]
        let okButton: XCUIElement = app.buttons["OK"]

        notificationView.tap()
        XCTAssert(!alert.exists)

        hasMessageActionSwitch.tap()
        notificationView.tap()
        // tapping on the notification should trigger an action
        XCTAssert(alert.exists)
        okButton.tap()

        actionButton.tap()
        XCTAssert(alert.exists)
        okButton.tap()

        hasActionButtonActionSwitch.tap()
        actionButton.tap()
        XCTAssert(!alert.exists)
    }

    func testStyles() throws {
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*style 0.*")).element.exists)
        app.buttons[".primaryToast"].tap()
        app.buttons[".neutralToast"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*style 1.*")).element.exists)
        app.buttons[".neutralToast"].tap()
        app.buttons[".primaryBar"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*style 2.*")).element.exists)
        app.buttons[".primaryBar"].tap()
        app.buttons[".primaryOutlineBar"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*style 3.*")).element.exists)
        app.buttons[".primaryOutlineBar"].tap()
        app.buttons[".neutralBar"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*style 4.*")).element.exists)
        app.buttons[".neutralBar"].tap()
        app.buttons[".dangerToast"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*style 5.*")).element.exists)
        app.buttons[".dangerToast"].tap()
        app.buttons[".warningToast"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*style 6.*")).element.exists)
    }

    func testWidth() throws {
        let flexibleWidthSwitch: XCUIElement = app.switches["Flexible Width Toast"].switches.firstMatch
        let notFlexible: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Notification View.*that is not flexible in width.*")
        let flexible: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Notification View.*that is flexible in width.*")

        XCTAssert(app.otherElements.containing(notFlexible).element.exists)
        flexibleWidthSwitch.tap()
        XCTAssert(app.otherElements.containing(flexible).element.exists)

        app.buttons[".primaryToast"].tap()
        app.buttons[".primaryBar"].tap()
        // bar notifications should have any information on whether or not they're flexible
        XCTAssert(!app.otherElements.containing(notFlexible).element.exists)
        XCTAssert(!app.otherElements.containing(flexible).element.exists)

        flexibleWidthSwitch.tap()
        XCTAssert(!app.otherElements.containing(notFlexible).element.exists)
        XCTAssert(!app.otherElements.containing(flexible).element.exists)
    }
}
