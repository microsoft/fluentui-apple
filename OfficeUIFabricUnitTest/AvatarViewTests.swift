//
//  Copyright Microsoft Corporation
//

import XCTest
@testable import OfficeUIFabric

class AvatarViewTests: XCTestCase {
	func testInitialsExtraction () {
		// Basic cases
		XCTAssertEqual(initials(name: nil, email: nil), "#")
		XCTAssertEqual(initials(name: "Satya Nadella", email: nil), "SN")
		XCTAssertEqual(initials(name: "Satya Nadella", email: "satya@microsoft.com"), "SN")
		XCTAssertEqual(initials(name: nil, email: "satya@microsoft.com"), "S")
		XCTAssertEqual(initials(name: "Nick Goose Bradshaw", email: nil), "NG")
		XCTAssertEqual(initials(name: "Mike \"Viper\" Metcalf", email: nil), "MM")
		
		// Non-standard characters
		XCTAssertEqual(initials(name: "😂", email: "happy@sevendwarves.net"), "H")
		XCTAssertEqual(initials(name: "🧐", email: "😀@😬.😂"), "#")
		XCTAssertEqual(initials(name: "☮︎", email: nil), "#")
		XCTAssertEqual(initials(name: "Satya Nadella 👑", email: "satya@microsoft.com"), "SN")
		XCTAssertEqual(initials(name: "Satya Nadella👑", email: "satya@microsoft.com"), "SN")
		XCTAssertEqual(initials(name: "Satya 👑 Nadella", email: "satya@microsoft.com"), "SN")
	}
}
