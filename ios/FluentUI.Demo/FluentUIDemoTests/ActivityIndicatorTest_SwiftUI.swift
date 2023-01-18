//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ActivityIndicatorTestSwiftUI: BaseTest {
    override var controlName: String { "ActivityIndicator" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    // tests activity indicator's start/stop functionality
    func testAnimating() throws {
        app.switches["Hides when stopped"].tap()
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")).exists)

        app.switches["Animating"].tap()
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is progress halted")).exists)
    }

    // ensures that activity indicator disappears when stopped
    func testHidingWhenStoppedOn() throws {
        let inProgress: NSPredicate = NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")
        XCTAssert(app.images.element(matching: inProgress).exists)
        app.switches["Animating"].tap()
        XCTAssert(!app.images.element(matching: inProgress).exists)
    }

    func testCustomColor() throws {
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of default color.*")).element.exists)

        app.switches["Uses custom color"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of color #0078d4.*")).element.exists)
    }

    func testSizeChanges() throws {
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 4")).element.exists)
        app.buttons[".xLarge"].tap()
        app.buttons[".large"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 3")).element.exists)
        app.buttons[".large"].tap()
        app.buttons[".medium"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 2")).element.exists)
        app.buttons[".medium"].tap()
        app.buttons[".small"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 1")).element.exists)
        app.buttons[".small"].tap()
        app.buttons[".xSmall"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 0")).element.exists)

        app.switches["Hides when stopped"].tap()
        app.switches["Animating"].tap()

        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 0")).element.exists)
        app.buttons[".xSmall"].tap()
        app.buttons[".small"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 1")).element.exists)
        app.buttons[".small"].tap()
        app.buttons[".medium"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 2")).element.exists)
        app.buttons[".medium"].tap()
        app.buttons[".large"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 3")).element.exists)
        app.buttons[".large"].tap()
        app.buttons[".xLarge"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*size 4")).element.exists)
    }

    func testDarkMode() throws {
        app.launchArguments.append("UITestingDarkModeEnabled")
        app.launch()
        app.staticTexts["SwiftUI Demo"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of default color.*")).element.exists)

        app.switches["Uses custom color"].tap()
        XCTAssert(app.images.containing(NSPredicate(format: "identifier MATCHES %@", "Activity Indicator.*of color #0086f0.*")).element.exists)
    }
}
