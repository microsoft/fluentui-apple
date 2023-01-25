//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class HUDTestSwiftUI: BaseTest {
    override var controlName: String { "HUD" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
//        app.buttons["Present HUD for 3 seconds"].tap()
//        // sleeps for 5 seconds to wait for presented HUD to disappear
//        sleep(5)
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    func testPresentation() throws {
        let blocksInteractionSwitch: XCUIElement = app.switches["Blocks interaction"]
        let presentHUDButton: XCUIElement = app.buttons["Present HUD for 3 seconds"]

        presentHUDButton.tap()
        // attempts to interact with Blocks interaction switch
        blocksInteractionSwitch.tap()
        // switch value should remain 1
        XCTAssertTrue(blocksInteractionSwitch.value as? String == "1")

        // sleeps for 5 seconds to wait for presented HUD to disappear
        sleep(5)

        blocksInteractionSwitch.tap()
        presentHUDButton.tap()
        blocksInteractionSwitch.tap()
        // switch value should change back to 1
        XCTAssertTrue(blocksInteractionSwitch.value as? String == "1")
    }

    func testLabels() throws {
        XCTAssertTrue(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "HUD with no label")).exists)
        app.textFields.firstMatch.tap()
        UIPasteboard.general.string = "label"
        app.textFields.element.doubleTap()
        app.menuItems["Paste"].tap()
        XCTAssertTrue(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "HUD with label \"label\"")).exists)
    }

    func testTypes() throws {
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "HUD.*activity")).element.exists)
        app.buttons[".activity"].tap()
        app.buttons[".success"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "HUD.*success")).element.exists)
        app.buttons[".success"].tap()
        app.buttons[".failure"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "HUD.*failure")).element.exists)
        app.buttons[".failure"].tap()
        app.buttons[".custom"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "HUD.*custom.*")).element.exists)
    }
}
