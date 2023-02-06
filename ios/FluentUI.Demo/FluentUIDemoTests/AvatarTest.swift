//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class AvatarTest: BaseTest {
    override var controlName: String { "Avatar" }

    func avatarExists(predicate: NSPredicate) -> Bool {
        return app.images.containing(predicate).element.exists
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssert(app.navigationBars[controlName].exists)
    }

    func testRings() throws {
        let showRingSwitch: XCUIElement = app.cells.containing(.staticText, identifier: "Show ring").firstMatch
        let useImageRingSwitch: XCUIElement = app.cells.containing(.staticText, identifier: "Use image based custom ring color").firstMatch
        let setInnerGapSwitch: XCUIElement = app.cells.containing(.staticText, identifier: "Set ring inner gap").firstMatch

        let noRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with no ring.*")
        let defaultRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with a default ring.*")
        let imageRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with an image based ring.*")
        let innerGap: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*an inner gap.*")
        let noInnerGap: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*no inner gap.*")

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

        let noPresence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 0.*")
        let oofPresence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence out of office.*")

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
}
