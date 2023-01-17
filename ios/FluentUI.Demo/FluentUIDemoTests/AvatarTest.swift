//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class AvatarTest: BaseTest {
    override var controlName: String { "Avatar" }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    func testSizes() throws {
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 72.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 56.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 40.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 32.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 24.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 20.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in size 16.*")).element.exists)
    }

    func testStyles() throws {
        // loops through the 6 different styles, with 0 as `default`
        for i in 0...5 {
            XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*in.*style \(i).*")).element.exists)
        }
    }

    func testImages() throws {
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*image.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*initials.*")).element.exists)
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*icon.*")).element.exists)
    }

    func testPresences() throws {
        let noPresence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence 0.*")
        let oofPresence: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence out of office.*")

        XCTAssert(app.images.containing(noPresence).element.exists)
        for i in 1...7 {
            XCTAssert(!app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence \(i).*")).element.exists)
        }
        XCTAssert(!app.images.containing(oofPresence).element.exists)

        app.cells.containing(.staticText, identifier: "Show presence").firstMatch.tap()
        XCTAssert(!app.images.containing(noPresence).element.exists)
        // loops through the 6 presences, with 1 as available
        for i in 1...7 {
            XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence \(i).*")).element.exists)
        }
        XCTAssert(!app.images.containing(oofPresence).element.exists)

        app.cells.containing(.staticText, identifier: "Set \"Out Of Office\"").firstMatch.tap()
        XCTAssert(!app.images.containing(noPresence).element.exists)
        for i in 0...7 {
            XCTAssert(!app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*presence \(i).*")).element.exists)
        }
        XCTAssert(app.images.containing(oofPresence).element.exists)
    }

    func testRing() throws {
        let noRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with no ring.*")
        let defaultRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with a default ring.*")
        let imageRing: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with an image based ring.*")

        XCTAssert(app.images.containing(noRing).element.exists)
        XCTAssert(!app.images.containing(defaultRing).element.exists)
        XCTAssert(!app.images.containing(imageRing).element.exists)

        app.cells.containing(.staticText, identifier: "Show ring").firstMatch.tap()
        XCTAssert(!app.images.containing(noRing).element.exists)
        XCTAssert(app.images.containing(defaultRing).element.exists)
        XCTAssert(!app.images.containing(imageRing).element.exists)

        app.cells.containing(.staticText, identifier: "Use image based custom ring color").firstMatch.tap()
        XCTAssert(!app.images.containing(noRing).element.exists)
        XCTAssert(!app.images.containing(defaultRing).element.exists)
        XCTAssert(app.images.containing(imageRing).element.exists)

        let innerGap: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*an inner gap.*")
        let noInnerGap: NSPredicate = NSPredicate(format: "identifier MATCHES %@", "Avatar.*with.*no inner gap.*")

        XCTAssert(app.images.containing(innerGap).element.exists)
        XCTAssert(!app.images.containing(noInnerGap).element.exists)
        app.cells.containing(.staticText, identifier: "Set ring inner gap").firstMatch.tap()
        XCTAssert(!app.images.containing(innerGap).element.exists)
        XCTAssert(app.images.containing(noInnerGap).element.exists)
    }
}
