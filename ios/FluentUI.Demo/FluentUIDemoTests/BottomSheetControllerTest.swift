//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class BottomSheetControllerTest: BaseTest {
    override var controlName: String { "BottomSheetController" }

    let bottomSheetPredicate: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Bottom Sheet View.*")

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    func testExpandable() throws {
        let isExpandableSwitch: XCUIElement = app.tables.element(boundBy: 0).cells.element(boundBy: 0)

        isExpandableSwitch.tap()
        sleep(1)
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Bottom Sheet View.*a resizing handle.*")).element.exists)
    }

    func testHidden() throws {
        let bottomSheet: XCUIElement = app.otherElements.containing(bottomSheetPredicate).element
        XCTAssert(bottomSheet.exists)

        let isHiddenSwitch: XCUIElement = app.tables.element(boundBy: 0).cells.element(boundBy: 1)
        isHiddenSwitch.tap()
        sleep(1)
        XCTAssert(!bottomSheet.isHittable)
    }

    func testFillWidth() throws {
        let shouldFillWidthSwitch: XCUIElement = app.tables.element(boundBy: 0).cells.element(boundBy: 2)

        shouldFillWidthSwitch.tap()
        sleep(1)
        XCTAssert(!app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Bottom Sheet View.*filled width.*")).element.exists)
    }

    func testScrollToHide() throws {
        let bottomSheet: XCUIElement = app.otherElements.containing(bottomSheetPredicate).element
        let scrollToHideSwitch: XCUIElement = app.tables.element(boundBy: 0).cells.element(boundBy: 3)

        XCTAssert(bottomSheet.exists)
        scrollToHideSwitch.tap()
        sleep(1)
        app.swipeUp()
        sleep(1)
        XCTAssert(!bottomSheet.isHittable)
    }

    func testCollapsedContent() throws {
        let hideCollapsedContentSwitch: XCUIElement = app.tables.element(boundBy: 0).cells.element(boundBy: 4)

        hideCollapsedContentSwitch.tap()
        sleep(1)
        XCTAssert(app.otherElements.containing(NSPredicate(format: "identifier MATCHES %@", "Bottom Sheet View.*an expanded content view.*")).element.exists)
    }
}
