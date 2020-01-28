//
// Copyright Microsoft Corporation
//

import AppKit
import OfficeUIFabric

/// A test identity to facilitate creating avatar views
fileprivate struct TestIdentity {
	let name: String?
	let email: String?
	let image: NSImage?
}

/// Some sample identities
fileprivate struct TestData {
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
	let displayedAvatarViews: [[AvatarView]] = avatarViews(sizes: [20,25,35,50,70],
														   identities: [
															TestData.annie,
															TestData.maor,
															TestData.annieBoyl,
															TestData.kat,
															TestData.anonymous,
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
			])
		
		containerView.orientation = .vertical
		
		view = containerView
	}

	/// Create a single avatar view from a given size and test identity
	static private func avatarView(size: CGFloat, identity: TestIdentity) -> AvatarView {
		return AvatarView(avatarSize: size,
						  contactName: identity.name,
						  contactEmail: identity.email,
						  contactImage: identity.image)
	}

	/// For each identity passed in, return an array of avatar views in the given sizes
	static private func avatarViews(sizes: [CGFloat], identities: [TestIdentity]) -> [[AvatarView]] {
		return identities.map { identity in
			sizes.map { avatarView(size: $0, identity: identity) }
		}
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
	
	static let testDataIndexForImages = 1
	static let testDataIndexForBackroundColor = 2
	static let testDataIndexForReuse = 3
	static let personaMale = "persona-male"
	static let personaFemale = "persona-female"
}
