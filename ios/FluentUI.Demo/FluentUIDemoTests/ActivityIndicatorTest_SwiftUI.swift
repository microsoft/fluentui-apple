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
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")).exists)
        app.switches["Animating"].tap()
        XCTAssert(!app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")).exists)
    }

    func testCustomColor() throws {
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress")).exists)
        app.switches["Uses custom color"].tap()
        XCTAssert(app.images.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Activity Indicator that is in progress with rgba values [0.0, 0.47058823529411764, 0.8313725490196079, 1.0]")).exists)
    }

    func testSizeChanges() throws {
        XCTAssert(app.images["Activity Indicator that is in progress and size 4"].exists)
        app.buttons[".xLarge"].tap()
        app.buttons[".large"].tap()
        XCTAssert(app.images["Activity Indicator that is in progress and size 3"].exists)
        app.buttons[".large"].tap()
        app.buttons[".medium"].tap()
        XCTAssert(app.images["Activity Indicator that is in progress and size 2"].exists)
        app.buttons[".medium"].tap()
        app.buttons[".small"].tap()
        XCTAssert(app.images["Activity Indicator that is in progress and size 1"].exists)
        app.buttons[".small"].tap()
        app.buttons[".xSmall"].tap()
        XCTAssert(app.images["Activity Indicator that is in progress and size 0"].exists)

        app.switches["Hides when stopped"].tap()
        app.switches["Animating"].tap()

        XCTAssert(app.images["Activity Indicator that is progress halted and size 0"].exists)
        app.buttons[".xSmall"].tap()
        app.buttons[".small"].tap()
        XCTAssert(app.images["Activity Indicator that is progress halted and size 1"].exists)
        app.buttons[".small"].tap()
        app.buttons[".medium"].tap()
        XCTAssert(app.images["Activity Indicator that is progress halted and size 2"].exists)
        app.buttons[".medium"].tap()
        app.buttons[".large"].tap()
        XCTAssert(app.images["Activity Indicator that is progress halted and size 3"].exists)
        app.buttons[".large"].tap()
        app.buttons[".xLarge"].tap()
        XCTAssert(app.images["Activity Indicator that is progress halted and size 4"].exists)
    }
}
