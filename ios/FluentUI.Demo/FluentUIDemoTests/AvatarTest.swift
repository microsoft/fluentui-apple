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
}
