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

    func testTitle() throws {
        let titleElement = app.staticTexts.matching(identifier: "ListItemTitle").firstMatch
        let textField: XCUIElement = app.textFields.matching(identifier: "titleTextField").firstMatch
        let newTitle = "A new title"

        textField.clearText()
        textField.typeText(newTitle)
        XCTAssert(titleElement.label == newTitle, "Title should update when passed in value changes")
    }

    func testSubtitle() throws {
        let subtitleElement: XCUIElement = app.staticTexts.matching(identifier: "ListItemSubtitle").firstMatch
        let textField: XCUIElement = app.textFields.matching(identifier: "subtitleTextField").firstMatch
        let newSubtitle = "A new subtitle"

        showSubtitleSwitch.tap()
        XCTAssert(subtitleElement.exists, "Subtitle should appear if a non empty string is passed in")

        textField.clearText()
        textField.typeText(newSubtitle)
        XCTAssert(subtitleElement.label == newSubtitle, "Subtitle should update when passed in value changes")

        textField.clearText()
        XCTAssertFalse(subtitleElement.exists, "Subtitle should not appear when string is empty")
    }

    func testFooter() throws {
        let footerElement: XCUIElement = app.staticTexts.matching(identifier: "ListItemFooter").firstMatch
        let textField: XCUIElement = app.textFields.matching(identifier: "footerTextField").firstMatch
        let newFooter = "A new footer"

        XCTAssertFalse(footerElement.exists, "Footer should not appear unless a subtitle is passed in")

        showSubtitleSwitch.tap()
        showFooterSwitch.tap()
        XCTAssert(footerElement.exists, "Footer should appear if a non empty string is passed in")

        textField.clearText()
        textField.typeText(newFooter)
        XCTAssert(footerElement.label == newFooter, "Footer should update when passed in value changes")

        showFooterSwitch.tap()
        XCTAssertFalse(footerElement.exists, "Footer should not appear when string is empty")
    }

    func testLeadingContent() throws {
        let showLeadingContentSwitch: XCUIElement = app.switches.matching(identifier: "leadingContentSwitch").switches.firstMatch
        let leadingContentElement: XCUIElement = app.images.matching(identifier: "ListItemLeadingContent").firstMatch
        let leadingContentSizeButton: XCUIElement = app.buttons.matching(identifier: "leadingContentSizePicker").firstMatch
        let zeroSizeButton: XCUIElement = app.buttons.matching(identifier: ".zero").firstMatch
        let smallSizeButton: XCUIElement = app.buttons.matching(identifier: ".small").firstMatch
        let mediumSizeButton: XCUIElement = app.buttons.matching(identifier: ".medium").firstMatch

        XCTAssert(leadingContentElement.exists, "Leading content should appear when a value is passed in")

        showLeadingContentSwitch.tap()
        XCTAssertFalse(leadingContentElement.exists, "Leading content should not appear when no value is passed in")

        showLeadingContentSwitch.tap()
        leadingContentSizeButton.tap()
        zeroSizeButton.tap()
        XCTAssertFalse(leadingContentElement.isHittable, "Leading content should not appear for size .zero")

        leadingContentSizeButton.tap()
        smallSizeButton.tap()
        XCTAssert(leadingContentElement.exists, "Leading content should appear for size .small")

        leadingContentSizeButton.tap()
        mediumSizeButton.tap()
        XCTAssert(leadingContentElement.exists, "Leading content should appear for size .medium")
    }

    func testTrailingContent() throws {
        let showTrailingContentSwitch: XCUIElement = app.switches.matching(identifier: "trailingContentSwitch").switches.firstMatch
        let leadingContentElement: XCUIElement = app.staticTexts.matching(identifier: "ListItemTrailingContent").firstMatch

        XCTAssert(leadingContentElement.exists, "Trailing content should appear when a value is passed in")

        showTrailingContentSwitch.tap()
        XCTAssertFalse(leadingContentElement.exists, "Trailing content should not appear when no value is passed in")
    }

    func testAccessoryType() throws {
        let accessoryImageElement: XCUIElement = app.images.matching(identifier: "ListItemAccessoryImage").firstMatch
        let accessoryButtonElement: XCUIElement = app.buttons.matching(identifier: "ListItemAccessoryDetailButton").firstMatch
        let accessoryTypeButton: XCUIElement = app.buttons.matching(identifier: "accessoryTypePicker").firstMatch
        let noneTypeButton: XCUIElement = app.buttons.matching(identifier: ".none").firstMatch
        let disclosureIndicatorTypeButton: XCUIElement = app.buttons.matching(identifier: ".disclosureIndicator").firstMatch
        let checkmarkTypeButton: XCUIElement = app.buttons.matching(identifier: ".checkmark").firstMatch
        let detailButtonTypeButton: XCUIElement = app.buttons.matching(identifier: ".detailButton").firstMatch

        accessoryTypeButton.tap()
        noneTypeButton.tap()
        XCTAssertFalse(accessoryImageElement.exists, "Accessory should not appear for .none type")

        accessoryTypeButton.tap()
        disclosureIndicatorTypeButton.tap()
        XCTAssert(accessoryImageElement.exists, "Accessory should appear for .disclosureIndicator type")
        XCTAssertFalse(accessoryImageElement.isHittable, "Accessory should not not have a tap target for .disclosureIndicator type")

        accessoryTypeButton.tap()
        checkmarkTypeButton.tap()
        XCTAssert(accessoryImageElement.exists, "Accessory should appear for .checkmark type")
        XCTAssertFalse(accessoryImageElement.isHittable, "Accessory should not not have a tap target for .checkmark type")

        accessoryTypeButton.tap()
        detailButtonTypeButton.tap()
        XCTAssert(accessoryButtonElement.exists, "Accessory should appear for .detailButton type")
        XCTAssert(accessoryButtonElement.isEnabled, "Accessory should have a tap target for .detailButton type")
    }

    // MARK: Helper variables

    var showSubtitleSwitch: XCUIElement {
        app.switches.matching(identifier: "subtitleSwitch").switches.firstMatch
    }

    var showFooterSwitch: XCUIElement {
        app.switches.matching(identifier: "footerSwitch").switches.firstMatch
    }
}
