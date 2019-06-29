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
	
	func testAccessibility () {
		// Avatar with name and email should be an accessibility element with the ax label and tooltip set to the contactName with an image role
		let satya = AvatarView(avatarSize: 0, contactName: "Satya Nadella", contactEmail: "satya@microsoft.com", contactImage: nil)
		XCTAssertTrue(satya.isAccessibilityElement())
		XCTAssertEqual(satya.accessibilityLabel(), "Satya Nadella")
		XCTAssertEqual(satya.accessibilityRole(), NSAccessibility.Role.image)
		XCTAssertEqual(satya.toolTip, "Satya Nadella")
		
		// When no name is provided, the ax label and tooltip should fallback to the contactEmail
		let noNameSatya = AvatarView(avatarSize: 0, contactName: nil, contactEmail: "satya@microsoft.com", contactImage: nil)
		XCTAssertTrue(noNameSatya.isAccessibilityElement())
		XCTAssertEqual(noNameSatya.accessibilityLabel(), "satya@microsoft.com")
		XCTAssertEqual(noNameSatya.accessibilityRole(), NSAccessibility.Role.image)
		XCTAssertEqual(noNameSatya.toolTip, "satya@microsoft.com")
		
		// When no name or email is provided, there isn't any valuable information to provide, so don't be an accessibility element
		let anonymousAvatar = AvatarView(avatarSize: 0, contactName: nil, contactEmail: nil, contactImage: nil)
		XCTAssertFalse(anonymousAvatar.isAccessibilityElement())
		XCTAssertNil(anonymousAvatar.accessibilityLabel())
		XCTAssertEqual(anonymousAvatar.accessibilityRole(), NSAccessibility.Role.unknown)
		XCTAssertNil(anonymousAvatar.toolTip)
		
	}
}
