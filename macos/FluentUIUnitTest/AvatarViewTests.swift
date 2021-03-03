//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import FluentUI

class AvatarViewTests: XCTestCase {
	func testValidInitialsCharacter () {
		XCTAssertTrue(Character("A").isValidInitialsCharacter)
		XCTAssertTrue(Character("Æ").isValidInitialsCharacter)
		XCTAssertTrue(Character("È").isValidInitialsCharacter)
		// same as above but with separate unicode scalars for the base character and the diacritic
		XCTAssertTrue(Character("E\u{0300}").isValidInitialsCharacter) // È
		XCTAssertTrue(Character("Å").isValidInitialsCharacter)
		XCTAssertTrue(Character("Ü").isValidInitialsCharacter)
		XCTAssertFalse(Character("😂").isValidInitialsCharacter)
		XCTAssertFalse(Character("👑").isValidInitialsCharacter)
		XCTAssertFalse(Character("王").isValidInitialsCharacter)
		XCTAssertFalse(Character("肖").isValidInitialsCharacter)
		XCTAssertFalse(Character("김").isValidInitialsCharacter)
		XCTAssertFalse(Character("").isValidInitialsCharacter)

		// Character with diacritic not available in Mac OS Roman
		XCTAssertFalse(Character("U\u{0304}").isValidInitialsCharacter) // Ū
	}

	func testInitialsExtraction () {
		// Basic cases
		XCTAssertNil(AvatarView.initials(name: nil, email: nil))
		XCTAssertEqual(AvatarView.initialsWithFallback(name: nil, email: nil), "#")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Annie Lindqvist", email: nil), "AL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Annie Lindqvist", email: "Annie.Lindqvist@example.com"), "AL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: nil, email: "Annie.Lindqvist@example.com"), "A")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Annie Boyl Lind", email: nil), "AB")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Annie \"Boyl\" Lind", email: nil), "AL")

		// Non-standard characters
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "😂", email: "happy@example.com"), "H")
		XCTAssertNil(AvatarView.initials(name: "🧐", email: "😀@😬.😂"))
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "🧐", email: "😀@😬.😂"), "#")
		XCTAssertNil(AvatarView.initials(name: "☮︎", email: nil))
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "☮︎", email: nil), "#")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Maor Sharett 👑", email: "Maor.Sharett@example.com"), "MS")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Maor Sharett👑", email: "Maor.Sharett@example.com"), "MS")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Maor 👑 Sharett", email: "Maor.Sharett@example.com"), "MS")

		// Complex characters
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "王小博", email: "email@example.com"), "E")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "王小博", email: nil), "#")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "肖赞", email: ""), "#")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "김보라", email: nil), "#")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "אָדָם", email: nil), "#")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "حسن", email: nil), "#")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: nil, email: "用户@例子.广告"), "#")

		XCTAssertEqual(AvatarView.initials(name: "王小博", email: "email@example.com"), "E")
		XCTAssertNil(AvatarView.initials(name: "王小博", email: nil))
		XCTAssertNil(AvatarView.initials(name: "肖赞", email: ""))
		XCTAssertNil(AvatarView.initials(name: "보라", email: nil))
		XCTAssertNil(AvatarView.initials(name: "אָדָם", email: nil))
		XCTAssertNil(AvatarView.initials(name: "حسن", email: nil))
		XCTAssertNil(AvatarView.initials(name: nil, email: "用户@例子.广告"))

		// Complex roman characters
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Êmïlÿ Çœłb", email: nil), "ÊÇ")

		// Complex roman characters with alternate unicode representation
		XCTAssertEqual("E\u{0300}", "È")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "E\u{0300}mïlÿ Çœłb", email: nil), "ÈÇ")

		// Mixed characters
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Sean 肖", email: nil), "S")

		// Whitespace
		XCTAssertEqual(AvatarView.initialsWithFallback(name: " Kat Larrson ", email: nil), "KL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "\nKat Larrson\n", email: nil), "KL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "\tKat Larrson ", email: nil), "KL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "\t Kat Larrson ", email: nil), "KL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Kat Larrson\n", email: nil), "KL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Kat Larrson \n", email: nil), "KL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Kat Larrson \t", email: nil), "KL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Kat \n Larrson", email: nil), "KL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Kat \t Larrson", email: nil), "KL")

		// Zero Width Space
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Annie\u{200B}Lindqvist", email: nil), "A")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "\u{200B}Annie\u{200B} \u{200B}Lindqvist\u{200B}", email: nil), "AL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Annie \u{200B} \u{200B}Lindqvist\u{200B}", email: nil), "AL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "\u{200B} Annie\u{200B} \u{200B}Lindqvist\u{200B}", email: nil), "AL")
		XCTAssertEqual(AvatarView.initialsWithFallback(name: "Annie\u{200B} \u{200B}Lindqvist \u{200B}", email: nil), "AL")
	}

	func testAccessibility () {
		// Avatar with name and email should be an accessibility element with the ax label and tooltip set to the contactName with an image role
		let nameAndEmailAvatar = AvatarView(avatarSize: 0, contactName: "Annie Lindqvist", contactEmail: "Annie.Lindqvist@example.com")
		XCTAssertTrue(nameAndEmailAvatar.isAccessibilityElement())
		XCTAssertEqual(nameAndEmailAvatar.accessibilityLabel(), "Annie Lindqvist")
		XCTAssertEqual(nameAndEmailAvatar.accessibilityRole(), NSAccessibility.Role.image)
		XCTAssertEqual(nameAndEmailAvatar.toolTip, "Annie Lindqvist")

		// When no name is provided, the ax label and tooltip should fallback to the contactEmail
		let emailOnlyAvatar = AvatarView(avatarSize: 0, contactEmail: "Annie.Lindqvist@example.com")
		XCTAssertTrue(emailOnlyAvatar.isAccessibilityElement())
		XCTAssertEqual(emailOnlyAvatar.accessibilityLabel(), "Annie.Lindqvist@example.com")
		XCTAssertEqual(emailOnlyAvatar.accessibilityRole(), NSAccessibility.Role.image)
		XCTAssertEqual(emailOnlyAvatar.toolTip, "Annie.Lindqvist@example.com")

		// When no name or email is provided, there isn't any valuable information to provide, so don't be an accessibility element
		let noNameNoEmailAvatar = AvatarView(avatarSize: 0)
		XCTAssertFalse(noNameNoEmailAvatar.isAccessibilityElement())
		XCTAssertNil(noNameNoEmailAvatar.accessibilityLabel())
		XCTAssertEqual(noNameNoEmailAvatar.accessibilityRole(), NSAccessibility.Role.unknown)
		XCTAssertNil(noNameNoEmailAvatar.toolTip)
	}

	func testAvatarColors () {
		// Verify if light and dark mode are interchangable
		let lightModeAppearnce = NSAppearance(named: .aqua)!
		let darkModeAppearance = NSAppearance(named: .darkAqua)!

		for (index, colorSet) in NSColor.avatarColors.enumerated() {
			let bgColor = colorSet.background
			let fgColor = colorSet.foreground
			let bgLightColor = bgColor.resolvedColor(lightModeAppearnce)
			let bgDarkColor = bgColor.resolvedColor(darkModeAppearance)
			let fgLightColor = fgColor.resolvedColor(lightModeAppearnce)
			let fgDarkColor = fgColor.resolvedColor(darkModeAppearance)

			XCTAssertEqual(bgLightColor,
						   fgDarkColor,
						   "Index \(index): Background color in light mode does not match Foreground color in dark mode.")

			XCTAssertEqual(bgDarkColor,
						   fgLightColor,
						   "Index \(index): Background color in dark mode does not match Foreground color in light mode.")
		}
	}

	func testHashAlgorithm () {
		XCTAssertEqual(AvatarView.colorIndex(for: "Annie.Lindqvist@example.com"), 5881)
		XCTAssertEqual(AvatarView.colorIndex(for: "Maor.Sharett@example.com"), 9659)
		XCTAssertEqual(AvatarView.colorIndex(for: "email@example.com"), 1874)
		XCTAssertEqual(AvatarView.colorIndex(for: "happy@example.com"), 1690)
		XCTAssertEqual(AvatarView.colorIndex(for: "Kat Larrson"), 11264)
		XCTAssertEqual(AvatarView.colorIndex(for: ""), 0)
	}
}
