//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class AvatarTestSwiftUI: BaseTest {
    override var controlName: String { "Avatar" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
    }

    func avatarExists(predicate: NSPredicate) -> Bool {
        return app.images.containing(predicate).element.exists
    }

    func avatarWithAttributeExists(attribute: String) -> Bool {
        return app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*\(attribute).*")).element.exists
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    func testImages() throws {
        let setImageSwitch: XCUIElement = app.switches["Set image"]
        let image: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*image.*")
        let initials: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*initials.*")
        let icon: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*icon.*")

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

    func testRings() throws {
        let ringVisibleSwitch: XCUIElement = app.switches["Ring visible"]
        let setImageRingSwitch: XCUIElement = app.switches["Set image based ring color"]
        let ringInnerGapSwitch: XCUIElement = app.switches["Ring inner gap"]

        let noRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with no ring.*")
        let defaultRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with a default ring.*")
        let imageRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with an image based ring.*")
        let innerGap: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*an inner gap.*")
        let noInnerGap: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*no inner gap.*")

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

    func testPresences() throws {
        XCTAssert(avatarWithAttributeExists(attribute: "presence 0"))
        app.buttons[".none"].firstMatch.tap()
        app.buttons[".available"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "presence 1"))
        app.buttons[".available"].tap()
        app.buttons[".away"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "presence 2"))
        app.buttons[".away"].tap()
        app.buttons[".blocked"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "presence 3"))
        app.buttons[".blocked"].tap()
        app.buttons[".busy"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "presence 4"))
        app.buttons[".busy"].tap()
        app.buttons[".doNotDisturb"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "presence 5"))
        app.buttons[".doNotDisturb"].tap()
        app.buttons[".offline"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "presence 6"))
        app.buttons[".offline"].tap()
        app.buttons[".unknown"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "presence 7"))

        app.switches["Out of office"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "presence out of office"))
    }

    // ensures that activity is only visible with images/initials (on default style, size 56)
    func testActivitiesImage() throws {
        app.switches["Show image"].tap()
        app.buttons.matching(NSPredicate(format: "label CONTAINS '.none'")).element(boundBy: 1).tap()
        app.buttons[".circle"].tap()
        app.buttons[".size72"].tap()
        app.buttons[".size56"].tap()

        XCTAssert(avatarWithAttributeExists(attribute: "activity 1"))
        app.switches["Set image"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "activity 1"))
        // removes name and image to set icon
        app.textFields.firstMatch.doubleTap()
        app.menuItems["Cut"].tap()
        app.switches["Set image"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))

        app.buttons[".circle"].tap()
        app.buttons[".square"].tap()

        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        // adds name back
        app.textFields.firstMatch.tap()
        app.menuItems["Paste"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "activity 2"))
        app.switches["Set image"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "activity 2"))
    }

    // ensures that activity is only visible on default style (on intials, size 56)
    func testActivitiesStyle() throws {
        app.switches["Show image"].tap()
        app.buttons.matching(NSPredicate(format: "label CONTAINS '.none'")).element(boundBy: 1).tap()
        app.buttons[".circle"].tap()
        app.buttons[".size72"].tap()
        app.buttons[".size56"].tap()

        XCTAssert(avatarWithAttributeExists(attribute: "activity 1"))
        app.buttons[".default"].tap()
        app.buttons[".accent"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".accent"].tap()
        app.buttons[".group"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".group"].tap()
        app.buttons[".outlined"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".outlined"].tap()
        app.buttons[".outlinedPrimary"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".outlinedPrimary"].tap()
        app.buttons[".overflow"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))

        app.buttons[".circle"].tap()
        app.buttons[".square"].tap()

        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".overflow"].tap()
        app.buttons[".outlinedPrimary"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".outlinedPrimary"].tap()
        app.buttons[".outlined"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".outlined"].tap()
        app.buttons[".group"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".group"].tap()
        app.buttons[".accent"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".accent"].tap()
        app.buttons[".default"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "activity 2"))
    }

    // ensures that activity is only visible on size 56 and 40 (on intials, default style)
    func testActivitiesSize() throws {
        app.switches["Show image"].tap()
        app.buttons.matching(NSPredicate(format: "label CONTAINS '.none'")).element(boundBy: 1).tap()
        app.buttons[".circle"].tap()

        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".size72"].tap()
        app.buttons[".size56"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "activity 1"))
        app.buttons[".size56"].tap()
        app.buttons[".size40"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "activity 1"))
        app.buttons[".size40"].tap()
        app.buttons[".size32"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".size32"].tap()
        app.buttons[".size24"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".size24"].tap()
        app.buttons[".size20"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".size20"].tap()
        app.buttons[".size16"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))

        app.buttons[".circle"].tap()
        app.buttons[".square"].tap()

        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".size16"].tap()
        app.buttons[".size20"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".size20"].tap()
        app.buttons[".size24"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".size24"].tap()
        app.buttons[".size32"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
        app.buttons[".size32"].tap()
        app.buttons[".size40"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "activity 2"))
        app.buttons[".size40"].tap()
        app.buttons[".size56"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "activity 2"))
        app.buttons[".size56"].tap()
        app.buttons[".size72"].tap()
        XCTAssert(!avatarWithAttributeExists(attribute: "activity"))
    }

    func testStyles() throws {
        XCTAssert(avatarWithAttributeExists(attribute: "style 0"))
        app.buttons[".default"].tap()
        app.buttons[".accent"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "style 1"))
        app.buttons[".accent"].tap()
        app.buttons[".group"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "style 2"))
        app.buttons[".group"].tap()
        app.buttons[".outlined"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "style 3"))
        app.buttons[".outlined"].tap()
        app.buttons[".outlinedPrimary"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "style 4"))
        app.buttons[".outlinedPrimary"].tap()
        app.buttons[".overflow"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "style 5"))
    }

    func testSizes() throws {
        XCTAssert(avatarWithAttributeExists(attribute: "size 72"))
        app.buttons[".size72"].tap()
        app.buttons[".size56"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "size 56"))
        app.buttons[".size56"].tap()
        app.buttons[".size40"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "size 40"))
        app.buttons[".size40"].tap()
        app.buttons[".size32"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "size 32"))
        app.buttons[".size32"].tap()
        app.buttons[".size24"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "size 24"))
        app.buttons[".size24"].tap()
        app.buttons[".size20"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "size 20"))
        app.buttons[".size20"].tap()
        app.buttons[".size16"].tap()
        XCTAssert(avatarWithAttributeExists(attribute: "size 16"))
    }
}
