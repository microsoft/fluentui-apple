//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class ActivityIndicatorTestSwiftUI: ActivityIndicatorTest {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.staticTexts["SwiftUI Demo"].tap()
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    override func testLaunch() throws {
        XCTAssert(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", controlName)).exists)
    }

    override func testStartStopHide() throws {
        let animatingSwitch: XCUIElement = app.switches["Animating"].switches.firstMatch
        let hidesWhenStoppedSwitch: XCUIElement = app.switches["Hides when stopped"].switches.firstMatch

        hidesWhenStoppedSwitch.tap()
        XCTAssert(activityIndicatorExists(status: inProgress))

        animatingSwitch.tap()
        XCTAssert(activityIndicatorExists(status: progressHalted))

        hidesWhenStoppedSwitch.tap()
        XCTAssert(!activityIndicatorExists(status: inProgress))

        animatingSwitch.tap()
        XCTAssert(activityIndicatorExists(status: inProgress))
    }

    override func testSizes() throws {
        let animatingSwitch: XCUIElement = app.switches["Animating"]
        let hidesWhenStoppedSwitch: XCUIElement = app.switches["Hides when stopped"]

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

        hidesWhenStoppedSwitch.tap()
        animatingSwitch.tap()

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
}
