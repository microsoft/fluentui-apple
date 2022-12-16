//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import FluentUI

class ActivityIndicatorSwiftUITest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()

        if app.staticTexts["FluentUI DEV"].exists {
            app.staticTexts["ActivityIndicator"].tap()
        } else if !app.staticTexts["ActivityIndicator"].exists {
            app.buttons["FluentUI DEV"].tap()
            app.staticTexts["ActivityIndicator"].tap()
        }
        app.staticTexts["SwiftUI Demo"].tap()
    }

    func testHidingWhenStoppedOn() throws {
        XCTAssert(app.images["Activity Indicator that is In progress of size 4"].exists)
        app.switches["Animating"].tap()
        XCTAssert(!app.images["Activity Indicator that is In progress of size 4"].exists)
    }

    func testHidingWhenStoppedOff() throws {
        app.switches["Hides when stopped"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size 4"].exists)
        app.switches["Animating"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size 4"].exists)
    }

    func testCustomColor() throws {
        XCTAssert(app.images["Activity Indicator that is In progress of size 4"].exists)
        app.switches["Uses custom color"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size 4 and color cyan blue"].exists)
    }

    func testSizeChanges() throws {
        XCTAssert(app.images["Activity Indicator that is In progress of size 4"].exists)
        app.buttons[".xLarge"].tap()
        app.buttons[".large"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size 3"].exists)
        app.buttons[".large"].tap()
        app.buttons[".medium"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size 2"].exists)
        app.buttons[".medium"].tap()
        app.buttons[".small"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size 1"].exists)
        app.buttons[".small"].tap()
        app.buttons[".xSmall"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size 0"].exists)

        app.switches["Hides when stopped"].tap()
        app.switches["Animating"].tap()

        XCTAssert(app.images["Activity Indicator that is Progress halted of size 0"].exists)
        app.buttons[".xSmall"].tap()
        app.buttons[".small"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size 1"].exists)
        app.buttons[".small"].tap()
        app.buttons[".medium"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size 2"].exists)
        app.buttons[".medium"].tap()
        app.buttons[".large"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size 3"].exists)
        app.buttons[".large"].tap()
        app.buttons[".xLarge"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size 4"].exists)
    }
}
