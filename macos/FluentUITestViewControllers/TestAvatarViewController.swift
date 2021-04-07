//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI

/// A test identity to facilitate creating avatar views
private struct TestIdentity {
	let name: String?
	let email: String?
	let image: NSImage?
}

/// Some sample identities
private struct TestData {
	static let annie = TestIdentity(name: "Annie Lindqvist", email: "Annie.Lindqvist@example.com", image: NSImage(named: TestAvatarViewController.personaFemale))
	static let maor = TestIdentity(name: "Maor Sharett", email: "Maor.Sharett@example.com", image: nil)
	static let annieBoyl = TestIdentity(name: "Annie Boyl Lind", email: "annie.boyl@example.com", image: nil)
	static let kat = TestIdentity(name: nil, email: "Kat.Larrson@example.com", image: nil)
	static let anonymous = TestIdentity(name: nil, email: nil, image: nil)
	private init() {}
}

/// Test view controller for the AvatarView class
class TestAvatarViewController: NSViewController {

	// Create various sizes of avatar views from our testa data
	let displayedAvatarViews: [[AvatarView]] = avatarViews(sizes: [24, 32, 40, 52, 72],
														   identities: [
															TestData.annie,
															TestData.maor,
															TestData.annieBoyl,
															TestData.kat,
															TestData.anonymous
		])

	override func loadView() {

		// Create a vertical stack view for each of our test identities
		let stackViews = displayedAvatarViews.map { avatarViews -> NSStackView in
			let stackView = NSStackView(views: avatarViews)
			stackView.orientation = .vertical
			let spacing = stackView.spacing
			stackView.edgeInsets = NSEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
			return stackView
		}

		// set our view to a horizontal stack view containing the vertical stack views
		let avatarViewsContentView = NSStackView(views: stackViews)
		avatarViewsContentView.alignment = .top

		let spacing = avatarViewsContentView.spacing
		avatarViewsContentView.edgeInsets = NSEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)

		let containerView = NSStackView(views: [
			avatarViewsContentView,
			NSButton(title: "Update Avatar Images", target: self, action: #selector(updateAvatarImages)),
			NSButton(title: "Update Avatar Background Colors", target: self, action: #selector(updateAvatarBackgroundColors)),
			NSButton(title: "Repurpose Avatar View", target: self, action: #selector(reuseAvatarView)),
			NSButton(title: "Show custom border", target: self, action: #selector(showCustomBorder))
			])

		containerView.orientation = .vertical

		view = containerView
	}

	/// Create a single avatar view from a given size and test identity
	private static func avatarView(size: CGFloat, identity: TestIdentity) -> AvatarView {
		let avatarView = AvatarView(avatarSize: size,
						  contactName: identity.name,
						  contactEmail: identity.email,
						  contactImage: identity.image)
		return avatarView
	}

	/// For each identity passed in, return an array of avatar views in the given sizes
	private static func avatarViews(sizes: [CGFloat], identities: [TestIdentity]) -> [[AvatarView]] {
		return identities.map { identity in
			sizes.map { avatarView(size: $0, identity: identity) }
		}
	}

	private static func colorfulImage(size: CGFloat) -> NSImage? {
		let gradientColors = [
			NSColor(red: 0.45, green: 0.29, blue: 0.79, alpha: 1).cgColor,
			NSColor(red: 0.18, green: 0.45, blue: 0.96, alpha: 1).cgColor,
			NSColor(red: 0.36, green: 0.80, blue: 0.98, alpha: 1).cgColor,
			NSColor(red: 0.45, green: 0.72, blue: 0.22, alpha: 1).cgColor,
			NSColor(red: 0.97, green: 0.78, blue: 0.27, alpha: 1).cgColor,
			NSColor(red: 0.94, green: 0.52, blue: 0.20, alpha: 1).cgColor,
			NSColor(red: 0.92, green: 0.26, blue: 0.16, alpha: 1).cgColor,
			NSColor(red: 0.45, green: 0.29, blue: 0.79, alpha: 1).cgColor]

		let colorfulGradient = CAGradientLayer()
		let frame = CGRect(x: 0, y: 0, width: size, height: size)
		colorfulGradient.frame = frame
		colorfulGradient.colors = gradientColors
		colorfulGradient.startPoint = CGPoint(x: 0.5, y: 0.5)
		colorfulGradient.endPoint = CGPoint(x: 0.5, y: 0)
		colorfulGradient.type = .conic

		let customBorderImage = NSImage(size: NSSize(width: size, height: size))
		customBorderImage.lockFocus()
		if let ctx = NSGraphicsContext.current?.cgContext {
			colorfulGradient.render(in: ctx)
		}
		customBorderImage.unlockFocus()
		return customBorderImage
	}

	// test setting an image on an existing avatar view
	@objc private func updateAvatarImages() {
		let maleImage = NSImage(named: TestAvatarViewController.personaMale)
		displayedAvatarViews[TestAvatarViewController.testDataIndexForImages].forEach { $0.contactImage = maleImage }
	}

	// test setting custom avatar background color
	@objc private func updateAvatarBackgroundColors() {
		displayedAvatarViews[TestAvatarViewController.testDataIndexForBackroundColor].forEach { $0.avatarBackgroundColor = .systemBlue }
	}

	// test repurposing an avatar view
	@objc private func reuseAvatarView() {
		displayedAvatarViews[TestAvatarViewController.testDataIndexForReuse].forEach {
			$0.contactName = "Ted Randall"
			$0.contactEmail = "ted.randall@example.com"
			$0.avatarSize = 25
		}
	}

	// test showing rainbow border color in avatar
	@objc private func showCustomBorder() {
		displayedAvatarViews[TestAvatarViewController.testDataIndexForBorderColor].forEach {
			$0.hasBorder = true
			if let customImage = TestAvatarViewController.colorfulImage(size: $0.avatarSize) {
				$0.borderColor = NSColor(patternImage: customImage)
			}
		}
	}

	static let testDataIndexForImages: Int = 1
	static let testDataIndexForBackroundColor: Int = 2
	static let testDataIndexForReuse: Int = 3
	static let testDataIndexForBorderColor: Int = 4
	static let personaMale: String = "persona-male"
	static let personaFemale: String = "persona-female"
}
