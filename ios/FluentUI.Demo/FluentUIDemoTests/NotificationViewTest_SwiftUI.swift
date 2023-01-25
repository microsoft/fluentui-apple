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
        XCTAssertTrue(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Notification View")).exists)
    }

    func testText() throws {
        let titleTextField: XCUIElement = app.textFields.element(boundBy: 0)
        let messageTextField: XCUIElement = app.textFields.element(boundBy: 1)
        let actionButtonTextField: XCUIElement = app.textFields.element(boundBy: 2)
        let attributedTextSwitch: XCUIElement = app.switches["Has Attributed Text: Strikethrough"]

        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*message \"Mail Archived\".*action button titled \"Undo\".*")).element.exists)

        titleTextField.tap()
        UIPasteboard.general.string = "title"
        titleTextField.doubleTap()
        app.menuItems["Paste"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View with title \"title\", message \"Mail Archived\".*action button titled \"Undo\".*")).element.exists)

        attributedTextSwitch.tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View with attributed title \"title\", attributed message \"Mail Archived\".*action button titled \"Undo\".*")).element.exists)

        titleTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        app.menuItems["Cut"].tap()
        messageTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        app.menuItems["Cut"].tap()
        actionButtonTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        app.menuItems["Cut"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View with no title, no message.*dismiss button.*")).element.exists)
    }

    func testImages() {
        let actionButtonTextField: XCUIElement = app.textFields.element(boundBy: 2)
        let setImageSwitch: XCUIElement = app.switches["Set image"]
        let setTrailingImageSwitch: XCUIElement = app.switches["Set trailing image"]

        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*no image.*")).element.exists)
        setImageSwitch.tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*image.*")).element.exists)

        setTrailingImageSwitch.tap()
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*trailing image.*")).element.exists)
        actionButtonTextField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        app.menuItems["Cut"].tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*trailing image.*")).element.exists)
        setTrailingImageSwitch.tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*dismiss button.*")).element.exists)
    }

    func testWidth() throws {
        let flexibleWidthSwitch: XCUIElement = app.switches["Flexible Width Toast"]

        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*that is not flexible in width.*")).element.exists)
        flexibleWidthSwitch.tap()
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Notification View.*that is flexible in width.*")).element.exists)

        app.buttons[".primaryToast"].tap()
        app.buttons[".neutralBar"].tap()
    }
}
