//
// Copyright Microsoft Corporation
//

import AppKit
import OfficeUIFabric

fileprivate struct Constants {
	static let testDataIndexForImages = 1
	static let testDataIndexForBackroundColor = 2
	static let satyaImageName = "satya"
	static let maverickImageName = "maverick"
	private init() {}
}

/// A test identity to facilitate creating avatar views
fileprivate struct TestIdentity {
	let name: String?
	let email: String?
	let image: NSImage?
}

/// Some sample identities
fileprivate struct TestData {
	static let satya = TestIdentity(name: "Satya Nadella", email: "satya@microsoft.com", image: NSImage(named: Constants.satyaImageName))
	static let maverick = TestIdentity(name: "Pete Mitchell", email: "maverick@miramar.edu", image: nil)
	static let goose = TestIdentity(name: "Nick O'Grady Bradshaw", email: "goose@miramar.edu", image: nil)
	static let charlie = TestIdentity(name: nil, email: "cblackwood@civiliancontractor.com", image: nil)
	static let bogey = TestIdentity(name: nil, email: nil, image: nil)
	private init() {}
}

/// Test view controller for the AvatarView class
class TestAvatarViewController: NSViewController {

	// Create various sizes of avatar views from our testa data
	let displayedAvatarViews: [[AvatarView]] = avatarViews(sizes: [50,100,200],
														   identities: [
															TestData.satya,
															TestData.maverick,
															TestData.goose,
															TestData.charlie,
															TestData.bogey,
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
			NSButton(title: "Update Avatar Background Colors", target: self, action: #selector(updateAvatarBackgroundColors))
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
		let maverickImage = NSImage(named: Constants.maverickImageName)
		displayedAvatarViews[Constants.testDataIndexForImages].forEach { $0.contactImage = maverickImage }
	}
	
	// test setting custom avatar background color
	@objc private func updateAvatarBackgroundColors() {
		displayedAvatarViews[Constants.testDataIndexForBackroundColor].forEach { $0.avatarBackgroundColor = .systemBlue }
	}
}
