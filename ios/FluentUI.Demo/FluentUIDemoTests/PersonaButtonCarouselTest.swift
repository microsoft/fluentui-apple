//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class PersonaButtonCarouselTest: BaseTest {
    override var controlName: String { "PersonaButtonCarousel" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }
}
