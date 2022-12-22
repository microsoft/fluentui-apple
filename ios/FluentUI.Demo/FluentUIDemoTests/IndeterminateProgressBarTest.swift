//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class IndeterminateProgressBarTest: BaseTest {
    override var controlName: String { "IndeterminateProgressBar" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }
}
