//
// Copyright Microsoft Corporation
//

import AppKit

fileprivate struct Constants {
	// the font size in the initials view will be scaled to this fraction of the avatarSize passed in
	static let fontSizeScalingDefault: CGFloat = 0.4
	// the text color of the note: doesn't change for dark mode
	static let initialsViewTextColor = NSColor.white
	// fall back to this text in the initials view when no usable name or email is provided
	static let fallbackInitial = "#"
	// the maximum number of initials to be displayed when we don't have an image
	static let maximumNumberOfInitials = 2
	// the unicode representation of the zero-width space character
	static let zeroWidthSpaceUnicodeCharacter = "\u{200B}"
	private init() {}
}

fileprivate enum DisplayStyle {
	case initials
	case image
}

open class AvatarView : NSView {

	/// Initializes the avatar view with a name, email, image, and size. If
	/// an image is provided, the avatar view will show the image. If no image is
	/// provided but a name is provided, the avatar view will show the initials of
	/// the name if initials can be extracted. Finally, if an email is provided but
	/// no name is provided, the first two characters of the email are used as
	/// initials.
	///
	/// @param avatarSize: the size in points for both the width and height
	/// 				of the avatar view
	/// @param contactName: the name of the contact with the
	///				format “<First Name> <Last Name>”
	/// @param contactEmail: the name of the contact with the
	///				format “<person>@<service>.<domain>”
	/// @param contactImage: the image of the contact
	@objc public init(avatarSize: CGFloat,
					  contactName: String?,
					  contactEmail: String?,
					  contactImage: NSImage?) {

		// TODO: GitHub Issue #9 use the Office avatar background colors
		avatarBackgroundColor = .systemPink
		self.contactName = contactName
		self.contactEmail = contactEmail
		self.contactImage = contactImage
		self.avatarSize = avatarSize
		
		displayStyle = contactImage == nil ? .initials : .image
		
		super.init(frame: .zero)

		wantsLayer = true
		layer?.cornerRadius = avatarSize / 2.0
		layer?.borderWidth = 1

		let constraints = [
			self.widthAnchor.constraint(equalToConstant: avatarSize),
			self.heightAnchor.constraint(equalToConstant: avatarSize),
		]
		
		NSLayoutConstraint.activate(constraints)

		updateViewStyle()
	}
	
	@available(*, unavailable) required public init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override open func updateLayer() {
		layer?.borderColor = NSColor.systemGray.cgColor
		if displayStyle == .initials {
			initialsView.layer?.backgroundColor = avatarBackgroundColor.cgColor
		}
	}

	/// The background color of the avatar view when no image is provided.
	/// Setting this property will override the default provided color.
	@objc open var avatarBackgroundColor: NSColor {
		didSet {
			guard oldValue != avatarBackgroundColor else {
				return
			}
			needsDisplay = true
		}
	}

	/// The image to be displayed in the AvatarView. If nil, the avatar’s initials
	/// will be displayed instead
	@objc open var contactImage: NSImage? {
		didSet {
			guard oldValue != contactImage else {
				return
			}

			contactImageView.image = contactImage

			// Update our display style
			displayStyle = contactImage == nil ? .initials : .image
		}
	}

	/// Internal storage of the contact's name
	private let contactName: String?

	/// Internal storage of the contact's email
	private let contactEmail: String?

	/// Internal storage of the size of this avatar view in points
	private let avatarSize: CGFloat

	/// A property for the display style based on whether an image exists or not.
	private var displayStyle: DisplayStyle {
		didSet {
			guard oldValue != displayStyle else {
				return
			}
			updateViewStyle()
		}
	}

	/// When an image is provided, this view is added to the view hierarchy
	private lazy var contactImageView: NSImageView = {
		let contactImageView = NSImageView()
		contactImageView.translatesAutoresizingMaskIntoConstraints = false
		contactImageView.image = contactImage
		contactImageView.imageScaling = .scaleProportionallyUpOrDown
		return contactImageView
	}()

	/// When no image is provided, this view is added to the view hierarchy
	private lazy var initialsView: NSView = {
		let initialsView = NSView()
		initialsView.wantsLayer = true
		initialsView.translatesAutoresizingMaskIntoConstraints = false
		initialsView.layer?.backgroundColor = avatarBackgroundColor.cgColor

		let textView = NSTextField(labelWithString: initials(name: contactName, email: contactEmail))
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.font = NSFont.systemFont(ofSize: avatarSize * Constants.fontSizeScalingDefault)
		textView.textColor = Constants.initialsViewTextColor
		initialsView.addSubview(textView)

		let constraints = [
			textView.centerXAnchor.constraint(equalTo: initialsView.centerXAnchor),
			textView.centerYAnchor.constraint(equalTo: initialsView.centerYAnchor),
			]

		NSLayoutConstraint.activate(constraints)

		return initialsView
	}()
	
	/// Update this view to use the proper style when switching from Image to Initials or vice-versa
	private func updateViewStyle() {
		// Remove all subviews as we will re-add the proper one below
		subviews = []
		
		let currentView = self.currentView()
		
		addSubview(currentView)
		let constraints = [
			currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			currentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			currentView.topAnchor.constraint(equalTo: self.topAnchor),
			currentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
		]
		
		NSLayoutConstraint.activate(constraints)
	}

	/// Get the internal view we should be using to represent this avatar
	///
	/// @return `initialsView` if `displayStyle` is `.initials`, `contactImageView` if it is `.image`
	private func currentView() -> NSView {
		switch displayStyle {
		case .initials:
			return initialsView
		case .image:
			return contactImageView
		}
	}
}

/// Extract the initials to display from a name and email combo
///
/// param contactName the name of the contact with the format “<First Name> <Last Name>”
/// param contactEmail the name of the contact with the format “<person>@<service>.<domain>"
///
/// @return if a name is passed in, return the first character of the first two names separated
/// by a space if the first character is a letter. If no usable name is passed in
/// return the first character of the email address passed in. If no usable email address is passed
/// in, return the character `#`.
func initials(name: String?, email: String?) -> String {
	var initials: String? = nil
	
	// Add the zero width space character to the standard whitespace and new lines character set
	let whitespaceNewlineAndZeroWidthSpace = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: Constants.zeroWidthSpaceUnicodeCharacter))
	
	if let name = name {
		let components = name.split(separator: " ")
		let nameComponentsWithUnicodeLetterFirstCharacters = components.filter {
			let trimmedString = $0.trimmingCharacters(in: whitespaceNewlineAndZeroWidthSpace)
			let unicodeScalars = trimmedString[trimmedString.startIndex].unicodeScalars
			let initialUnicodeScalar = unicodeScalars[unicodeScalars.startIndex]
			return CharacterSet.letters.contains(initialUnicodeScalar)
		}
		if nameComponentsWithUnicodeLetterFirstCharacters.count > 0 {
			initials = String(nameComponentsWithUnicodeLetterFirstCharacters.prefix(Constants.maximumNumberOfInitials).map { $0[$0.startIndex] })
		}
	}
	
	if initials == nil, let email = email?.trimmingCharacters(in: whitespaceNewlineAndZeroWidthSpace) {
		let unicodeScalars = email[email.startIndex].unicodeScalars
		let initialUnicodeScalar = unicodeScalars[unicodeScalars.startIndex]
		if CharacterSet.letters.contains(initialUnicodeScalar) {
			initials = String(initialUnicodeScalar)
		}
	}

	// default to # when we have nothing to base our initials off of
	return initials?.localizedUppercase ?? Constants.fallbackInitial
}
