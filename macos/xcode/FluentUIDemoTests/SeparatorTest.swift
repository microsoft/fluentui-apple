//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class SeparatorTest: BaseTest {
	override var controlName: String { "Separator" }

	// launch test that ensures the demo app does not crash and is on the correct control page
	func testLaunch() throws {
		XCTAssertTrue(app.cells.containing(.staticText, identifier: controlName).firstMatch.isSelected)
	}
}
