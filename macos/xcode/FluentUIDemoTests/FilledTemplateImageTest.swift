//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class FilledTemplateImageTest: BaseTest {
	override var controlName: String { "FilledTemplateImage" }

	// launch test that ensures the demo app does not crash and is on the correct control page
	func testLaunch() throws {
		XCTAssert(app.cells.containing(.staticText, identifier: controlName).firstMatch.isSelected)
	}
}
