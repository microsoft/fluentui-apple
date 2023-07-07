//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class HUDTestSwiftUI: BaseTest {
    override var controlName: String { "HUD" }

    let sleepSeconds: UInt32 = 5

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
        app.buttons["Present HUD for 3 seconds"].tap()
        // sleeps to wait for presented HUD to disappear
        sleep(sleepSeconds)
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    func testBlocksPresentation() throws {
        let blocksInteractionSwitch: XCUIElement = app.switches["Blocks interaction"].switches.firstMatch
        let presentHUDButton: XCUIElement = app.buttons["Present HUD for 3 seconds"]

        // switch value should start as 1
        XCTAssert(blocksInteractionSwitch.value as? String == "1")
        presentHUDButton.tap()
        // attempts to interact with "Blocks interaction" switch
        blocksInteractionSwitch.tap()
        // switch value should remain 1
        XCTAssert(blocksInteractionSwitch.value as? String == "1")

        // sleeps to wait for presented HUD to disappear
        sleep(sleepSeconds)

        // turns off block interaction functionality
        blocksInteractionSwitch.tap()
        // switch value should start as 0
        XCTAssert(blocksInteractionSwitch.value as? String == "0")
        presentHUDButton.tap()
        // attempts to interact with "Blocks interaction" switch
        blocksInteractionSwitch.tap()
        // switch value should change back to 1
        XCTAssert(blocksInteractionSwitch.value as? String == "1")
    }

    func testLabels() throws {
        let textField: XCUIElement = app.textFields.firstMatch
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "HUD with no label")).exists)
        textField.tap()
        textField.typeText("label\n")
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "HUD with label \"label\"")).exists)
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
