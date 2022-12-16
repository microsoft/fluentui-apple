//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
import FluentUI

class ActivityIndicatorTest: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        
        if app.staticTexts["FluentUI DEV"].exists {
            app.staticTexts["ActivityIndicator"].tap()
        }
        else if !app.staticTexts["ActivityIndicator"].exists {
            app.buttons["FluentUI DEV"].tap()
            app.staticTexts["ActivityIndicator"].tap()
        }
    }

    func testSizes() throws {
        XCTAssertEqual(app.images.element(boundBy: 0).identifier, "Activity Indicator that is In progress of size xLarge")
        XCTAssertEqual(app.images.element(boundBy: 1).identifier, "Activity Indicator that is In progress of size large")
        XCTAssertEqual(app.images.element(boundBy: 2).identifier, "Activity Indicator that is In progress of size medium")
        XCTAssertEqual(app.images.element(boundBy: 3).identifier, "Activity Indicator that is In progress of size small")
        XCTAssertEqual(app.images.element(boundBy: 4).identifier, "Activity Indicator that is In progress of size xSmall")
    }
    
    func testColor() throws {
        XCTAssertEqual(app.images.element(boundBy: 5).identifier, "Activity Indicator that is In progress of size xLarge and color cyan blue")
        XCTAssertEqual(app.images.element(boundBy: 6).identifier, "Activity Indicator that is In progress of size large and color cyan blue")
        XCTAssertEqual(app.images.element(boundBy: 7).identifier, "Activity Indicator that is In progress of size medium and color cyan blue")
        XCTAssertEqual(app.images.element(boundBy: 8).identifier, "Activity Indicator that is In progress of size small and color cyan blue")
        XCTAssertEqual(app.images.element(boundBy: 9).identifier, "Activity Indicator that is In progress of size xSmall and color cyan blue")
    }
    
    func testStartStopHide() throws {
        XCTAssert(app.images["In progress"].exists)
        app.buttons["Start / Stop activity"].tap()
        XCTAssert(!app.images["In progress"].exists)
        
        app.cells.containing(.staticText, identifier: "Hides when stopped").firstMatch.tap()
        XCTAssert(app.images["Progress halted"].exists)
        
        app.buttons["Start / Stop activity"].tap()
        XCTAssert(app.images["In progress"].exists)
    }
}
