//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class AvatarTest: BaseTest {
    override var controlName: String { "Avatar" }

    let image: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*image.*")
    let initials: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*initials.*")
    let icon: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*icon.*")

    let noRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with no ring.*")
    let defaultRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with a default ring.*")
    let imageRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with an image based ring.*")

    let innerGap: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*an inner gap.*")
    let noInnerGap: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*no inner gap.*")

    let noPresence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 0.*")
    let oofPresence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence out of office.*")

    let size72: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 72.*")
    let size56: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 56.*")
    let size40: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 40.*")
    let size32: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 32.*")
    let size24: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 24.*")
    let size20: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 20.*")
    let size16: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 16.*")

    func avatarExists(predicate: NSPredicate) -> Bool {
        return app.images.containing(predicate).element.exists
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    func testImages() throws {
        XCTAssert(avatarExists(predicate: image))
        XCTAssert(avatarExists(predicate: initials))
        XCTAssert(avatarExists(predicate: icon))
    }

    func testRings() throws {
        let showRingSwitch: XCUIElement = app.cells.containing(.staticText, identifier: "Show ring").firstMatch
        let useImageRingSwitch: XCUIElement = app.cells.containing(.staticText, identifier: "Use image based custom ring color").firstMatch
        let setInnerGapSwitch: XCUIElement = app.cells.containing(.staticText, identifier: "Set ring inner gap").firstMatch

        XCTAssert(avatarExists(predicate: noRing))
        XCTAssert(!avatarExists(predicate: defaultRing))
        XCTAssert(!avatarExists(predicate: imageRing))

        showRingSwitch.tap()
        XCTAssert(!avatarExists(predicate: noRing))
        XCTAssert(avatarExists(predicate: defaultRing))
        XCTAssert(!avatarExists(predicate: imageRing))

        useImageRingSwitch.tap()
        XCTAssert(!avatarExists(predicate: noRing))
        XCTAssert(!avatarExists(predicate: defaultRing))
        XCTAssert(avatarExists(predicate: imageRing))

        XCTAssert(avatarExists(predicate: innerGap))
        XCTAssert(!avatarExists(predicate: noInnerGap))
        setInnerGapSwitch.tap()
        XCTAssert(!avatarExists(predicate: innerGap))
        XCTAssert(avatarExists(predicate: noInnerGap))
    }

    func testPresences() throws {
        let showPresenceSwitch: XCUIElement = app.cells.containing(.staticText, identifier: "Show presence").firstMatch
        let setOOFSwitch: XCUIElement = app.cells.containing(.staticText, identifier: "Set \"Out Of Office\"").firstMatch

        XCTAssert(avatarExists(predicate: noPresence))
        // loops through the 6 presences, with 1 as available
        for i in 1...7 {
            let presence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence \(i).*")
            XCTAssert(!avatarExists(predicate: presence))
        }
        XCTAssert(!avatarExists(predicate: oofPresence))

        showPresenceSwitch.tap()
        XCTAssert(!avatarExists(predicate: noPresence))
        for i in 1...7 {
            let presence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence \(i).*")
            XCTAssert(avatarExists(predicate: presence))
        }
        XCTAssert(!avatarExists(predicate: oofPresence))

        setOOFSwitch.tap()
        XCTAssert(!avatarExists(predicate: noPresence))
        for i in 0...7 {
            let presence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence \(i).*")
            XCTAssert(!avatarExists(predicate: presence))
        }
        XCTAssert(avatarExists(predicate: oofPresence))
    }

    func testStyles() throws {
        // loops through the 6 different styles, with 0 as `default`
        for i in 0...5 {
            let style: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*style \(i).*")
            XCTAssert(avatarExists(predicate: style))
        }
    }

    func testSizes() throws {
        XCTAssert(avatarExists(predicate: size72))
        XCTAssert(avatarExists(predicate: size56))
        XCTAssert(avatarExists(predicate: size40))
        XCTAssert(avatarExists(predicate: size32))
        XCTAssert(avatarExists(predicate: size24))
        XCTAssert(avatarExists(predicate: size20))
        XCTAssert(avatarExists(predicate: size16))
    }
}
