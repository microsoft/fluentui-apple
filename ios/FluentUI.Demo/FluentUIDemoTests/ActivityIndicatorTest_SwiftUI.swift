//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import FluentUI

class ActivityIndicatorSwiftUITest: XCTestCase {
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
        app.staticTexts["SwiftUI Demo"].tap()
    }
    
    func testHidingWhenStoppedOn() throws {
        XCTAssert(app.images["Activity Indicator that is In progress of size xLarge"].exists)
        app.switches["Animating"].tap()
        XCTAssert(!app.images["Activity Indicator that is In progress of size xLarge"].exists)
    }
    
    func testHidingWhenStoppedOff() throws {
        app.switches["Hides when stopped"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size xLarge"].exists)
        app.switches["Animating"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size xLarge"].exists)
    }
    
    func testCustomColor() throws {
        XCTAssert(app.images["Activity Indicator that is In progress of size xLarge"].exists)
        app.switches["Uses custom color"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size xLarge and color cyan blue"].exists)
    }

    func testSizeChanges() throws {
        XCTAssert(app.images["Activity Indicator that is In progress of size xLarge"].exists)
        app.buttons[".xLarge"].tap()
        app.buttons[".large"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size large"].exists)
        app.buttons[".large"].tap()
        app.buttons[".medium"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size medium"].exists)
        app.buttons[".medium"].tap()
        app.buttons[".small"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size small"].exists)
        app.buttons[".small"].tap()
        app.buttons[".xSmall"].tap()
        XCTAssert(app.images["Activity Indicator that is In progress of size xSmall"].exists)
        
        app.switches["Hides when stopped"].tap()
        app.switches["Animating"].tap()
        
        XCTAssert(app.images["Activity Indicator that is Progress halted of size xSmall"].exists)
        app.buttons[".xSmall"].tap()
        app.buttons[".small"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size small"].exists)
        app.buttons[".small"].tap()
        app.buttons[".medium"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size medium"].exists)
        app.buttons[".medium"].tap()
        app.buttons[".large"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size large"].exists)
        app.buttons[".large"].tap()
        app.buttons[".xLarge"].tap()
        XCTAssert(app.images["Activity Indicator that is Progress halted of size xLarge"].exists)
    }
}
