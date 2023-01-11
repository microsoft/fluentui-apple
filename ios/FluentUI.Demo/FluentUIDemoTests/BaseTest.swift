//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class BaseTest: XCTestCase {
    let app = XCUIApplication()
    // must be overridden
    var controlName: String { "Base" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()
        app.staticTexts[controlName].tap()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        UserDefaults.standard.removeObject(forKey: "LastDemoController")
        app.terminate()
    }
}
