//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class AvatarTestSwiftUI: AvatarTest {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    override func testLaunch() throws {
        XCTAssertTrue(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    override func testImages() throws {
        let setImageSwitch: XCUIElement = app.switches["Set image"]

        setImageSwitch.tap()
        XCTAssert(avatarExists(predicate: image))
        XCTAssert(!avatarExists(predicate: initials))
        XCTAssert(!avatarExists(predicate: icon))

        setImageSwitch.tap()
        XCTAssert(!avatarExists(predicate: image))
        XCTAssert(avatarExists(predicate: initials))
        XCTAssert(!avatarExists(predicate: icon))

        app.textFields.firstMatch.doubleTap()
        app.menuItems["Cut"].tap()
        XCTAssert(!avatarExists(predicate: image))
        XCTAssert(!avatarExists(predicate: initials))
        XCTAssert(avatarExists(predicate: icon))

        setImageSwitch.tap()
        XCTAssert(avatarExists(predicate: image))
        XCTAssert(!avatarExists(predicate: initials))
        XCTAssert(!avatarExists(predicate: icon))
    }

    override func testRings() throws {
        let ringVisibleSwitch: XCUIElement = app.switches["Ring visible"]
        let setImageRingSwitch: XCUIElement = app.switches["Set image based ring color"]
        let ringInnerGapSwitch: XCUIElement = app.switches["Ring inner gap"]

        ringVisibleSwitch.tap()
        XCTAssert(avatarExists(predicate: noRing))
        XCTAssert(!avatarExists(predicate: defaultRing))
        XCTAssert(!avatarExists(predicate: imageRing))

        ringVisibleSwitch.tap()
        XCTAssert(!avatarExists(predicate: noRing))
        XCTAssert(avatarExists(predicate: defaultRing))
        XCTAssert(!avatarExists(predicate: imageRing))

        setImageRingSwitch.tap()
        XCTAssert(!avatarExists(predicate: noRing))
        XCTAssert(!avatarExists(predicate: defaultRing))
        XCTAssert(avatarExists(predicate: imageRing))

        XCTAssert(avatarExists(predicate: innerGap))
        XCTAssert(!avatarExists(predicate: noInnerGap))
        ringInnerGapSwitch.tap()
        XCTAssert(!avatarExists(predicate: innerGap))
        XCTAssert(avatarExists(predicate: noInnerGap))
    }

    override func testPresences() throws {
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 0.*")).element.exists)
        app.buttons[".none"].tap()
        app.buttons[".available"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 1.*")).element.exists)
        app.buttons[".available"].tap()
        app.buttons[".away"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 2.*")).element.exists)
        app.buttons[".away"].tap()
        app.buttons[".blocked"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 3.*")).element.exists)
        app.buttons[".blocked"].tap()
        app.buttons[".busy"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 4.*")).element.exists)
        app.buttons[".busy"].tap()
        app.buttons[".doNotDisturb"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 5.*")).element.exists)
        app.buttons[".doNotDisturb"].tap()
        app.buttons[".offline"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 6.*")).element.exists)
        app.buttons[".offline"].tap()
        app.buttons[".unknown"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 7.*")).element.exists)

        app.switches["Out of office"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence out of office.*")).element.exists)
    }

    override func testStyles() throws {
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in.*style 0.*")).element.exists)
        app.buttons[".default"].tap()
        app.buttons[".accent"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in.*style 1.*")).element.exists)
        app.buttons[".accent"].tap()
        app.buttons[".group"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in.*style 2.*")).element.exists)
        app.buttons[".group"].tap()
        app.buttons[".outlined"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in.*style 3.*")).element.exists)
        app.buttons[".outlined"].tap()
        app.buttons[".outlinedPrimary"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in.*style 4.*")).element.exists)
        app.buttons[".outlinedPrimary"].tap()
        app.buttons[".overflow"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in.*style 5.*")).element.exists)
    }

    override func testSizes() throws {
        XCTAssert(avatarExists(predicate: size72))
        app.buttons[".size72"].tap()
        app.buttons[".size56"].tap()
        XCTAssert(avatarExists(predicate: size56))
        app.buttons[".size56"].tap()
        app.buttons[".size40"].tap()
        XCTAssert(avatarExists(predicate: size40))
        app.buttons[".size40"].tap()
        app.buttons[".size32"].tap()
        XCTAssert(avatarExists(predicate: size32))
        app.buttons[".size32"].tap()
        app.buttons[".size24"].tap()
        XCTAssert(avatarExists(predicate: size24))
        app.buttons[".size24"].tap()
        app.buttons[".size20"].tap()
        XCTAssert(avatarExists(predicate: size20))
        app.buttons[".size20"].tap()
        app.buttons[".size16"].tap()
        XCTAssert(avatarExists(predicate: size16))
    }
}
